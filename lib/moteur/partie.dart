import 'dart:math';

import 'case_plateau.dart';
import 'joueur.dart';
import 'plateau.dart';

/// Où en est le tour courant. L'interface (Flutter) se contente de
/// regarder cette valeur pour savoir quels boutons afficher.
enum Phase {
  /// On attend que le joueur courant lance les dés.
  attenteLancer,

  /// Le joueur est tombé sur une propriété libre : acheter ou passer.
  attenteAchat,

  /// Plus rien à faire, on peut passer au joueur suivant.
  finDeTour,

  /// Il ne reste qu'un joueur solvable.
  terminee,
}

class Partie {
  final List<CasePlateau> plateau;
  final List<Joueur> joueurs;
  final Map<int, EtatPropriete> proprietes;
  final Random _random;

  int joueurCourantIndex = 0;
  Phase phase = Phase.attenteLancer;
  Lancer? dernierLancer;
  int _doublesConsecutifs = 0;

  /// Historique lisible, pratique pour déboguer et pour afficher un journal.
  final List<String> journal = [];

  Partie({
    required this.joueurs,
    List<CasePlateau>? plateau,
    Random? random,
  })  : plateau = plateau ?? plateauPortAval,
        _random = random ?? Random(),
        proprietes = {
          for (final c in (plateau ?? plateauPortAval))
            if (c is CaseAchetable) c.index: EtatPropriete(),
        };

  // -------------------------------------------------------------------------
  // Lecture de l'état (ce que l'UI consulte)
  // -------------------------------------------------------------------------

  Joueur get joueurCourant => joueurs[joueurCourantIndex];

  CasePlateau get caseCourante => plateau[joueurCourant.position];

  List<Joueur> get joueursActifs =>
      joueurs.where((j) => !j.enFaillite).toList();

  Joueur? joueurParId(int? id) {
    if (id == null) return null;
    return joueurs.firstWhere((j) => j.id == id);
  }

  /// La propriété sur laquelle est posé le joueur courant, si elle est à vendre.
  CaseAchetable? get proprieteAVendre {
    final c = caseCourante;
    if (c is! CaseAchetable) return null;
    return proprietes[c.index]!.estLibre ? c : null;
  }

  // -------------------------------------------------------------------------
  // Actions (ce que l'UI, l'IA ou le réseau appellent)
  // -------------------------------------------------------------------------

  /// Action 1 : lancer les dés et se déplacer.
  void lancerDes() {
    _exige(phase == Phase.attenteLancer, 'Ce n\'est pas le moment de lancer.');

    final lancer = Lancer.aleatoire(_random);
    dernierLancer = lancer;
    final j = joueurCourant;
    _log('${j.nom} lance : $lancer');

    if (j.enPrison) {
      _gererPrison(lancer);
      return;
    }

    if (lancer.estDouble) {
      _doublesConsecutifs++;
      if (_doublesConsecutifs == 3) {
        _log('Troisième double d\'affilée : ${j.nom} va en prison.');
        _envoyerEnPrison(j);
        phase = Phase.finDeTour;
        return;
      }
    } else {
      _doublesConsecutifs = 0;
    }

    _avancer(j, lancer.total);
    _resoudreCase();
  }

  /// Action 2a : acheter la propriété sur laquelle on vient de tomber.
  void acheter() {
    _exige(phase == Phase.attenteAchat, 'Aucun achat en attente.');
    final propriete = proprieteAVendre!;
    final j = joueurCourant;

    _exige(j.argent >= propriete.prix, 'Fonds insuffisants.');
    j.argent -= propriete.prix;
    proprietes[propriete.index]!.proprietaireId = j.id;
    _log('${j.nom} achète ${propriete.nom} pour ${propriete.prix} €.');

    phase = Phase.finDeTour;
  }

  /// Action 2b : renoncer à l'achat.
  ///
  /// Dans la règle officielle la propriété part aux enchères : c'est un bon
  /// deuxième exercice, mais commence sans.
  void refuserAchat() {
    _exige(phase == Phase.attenteAchat, 'Aucun achat en attente.');
    _log('${joueurCourant.nom} ne prend pas ${proprieteAVendre!.nom}.');
    phase = Phase.finDeTour;
  }

  /// Action 3 : passer la main.
  void terminerTour() {
    _exige(phase == Phase.finDeTour, 'Le tour n\'est pas terminé.');

    if (joueursActifs.length <= 1) {
      phase = Phase.terminee;
      _log('Partie terminée. Vainqueur : ${joueursActifs.first.nom}');
      return;
    }

    // Un double rejoue (sauf s'il vient d'être envoyé en prison).
    final rejoue = dernierLancer?.estDouble == true &&
        !joueurCourant.enPrison &&
        _doublesConsecutifs > 0;

    if (!rejoue) {
      _doublesConsecutifs = 0;
      do {
        joueurCourantIndex = (joueurCourantIndex + 1) % joueurs.length;
      } while (joueurCourant.enFaillite);
    }

    phase = Phase.attenteLancer;
  }

  // -------------------------------------------------------------------------
  // Construction
  // -------------------------------------------------------------------------

  bool peutConstruire(int indexCase) {
    final c = plateau[indexCase];
    if (c is! CaseTerrain) return false;
    final etat = proprietes[indexCase]!;
    if (etat.proprietaireId != joueurCourant.id) return false;
    if (etat.hypothequee || etat.constructions >= 5) return false;
    if (!possedeGroupeComplet(joueurCourant.id, c.groupe)) return false;
    return joueurCourant.argent >= c.prixConstruction;
  }

  void construire(int indexCase) {
    _exige(peutConstruire(indexCase), 'Construction impossible ici.');
    final c = plateau[indexCase] as CaseTerrain;
    joueurCourant.argent -= c.prixConstruction;
    proprietes[indexCase]!.constructions++;
    _log('${joueurCourant.nom} construit sur ${c.nom} '
        '(${proprietes[indexCase]!.constructions}).');
  }

  bool possedeGroupeComplet(int joueurId, GroupeCouleur groupe) {
    final terrains = plateau
        .whereType<CaseTerrain>()
        .where((t) => t.groupe == groupe);
    return terrains
        .every((t) => proprietes[t.index]!.proprietaireId == joueurId);
  }

  // -------------------------------------------------------------------------
  // Mécanique interne
  // -------------------------------------------------------------------------

  void _avancer(Joueur j, int cases) {
    final nouvelle = (j.position + cases) % plateau.length;
    if (nouvelle < j.position) {
      final depart = plateau[0] as CaseDepart;
      j.argent += depart.prime;
      _log('${j.nom} passe par la case Départ (+${depart.prime} €).');
    }
    j.position = nouvelle;
    _log('${j.nom} arrive sur ${plateau[nouvelle].nom}.');
  }

  void _resoudreCase() {
    final c = caseCourante;
    final j = joueurCourant;

    if (c is CaseAchetable) {
      _resoudreAchetable(c);
      return;
    }

    switch (c) {
      case CaseTaxe(:final montant, :final nom):
        _log('$nom : ${j.nom} paie $montant €.');
        _payer(j, null, montant);
      case CaseAllezEnPrison():
        _envoyerEnPrison(j);
      case CaseCarte(:final paquet):
        // TODO : implémenter les paquets de cartes.
        _log('Carte ${paquet.name} : pas encore implémenté.');
      case CaseDepart() || CasePrison() || CaseParcGratuit():
        break; // rien à faire
      case CaseTerrain() || CaseGare() || CaseCompagnie():
        break; // déjà traité plus haut
    }

    if (phase != Phase.attenteAchat) phase = Phase.finDeTour;
  }

  void _resoudreAchetable(CaseAchetable c) {
    final etat = proprietes[c.index]!;
    final j = joueurCourant;

    if (etat.estLibre) {
      if (j.argent >= c.prix) {
        phase = Phase.attenteAchat;
      } else {
        _log('${c.nom} est libre mais ${j.nom} n\'a pas les moyens.');
        phase = Phase.finDeTour;
      }
      return;
    }

    if (etat.proprietaireId == j.id) {
      _log('${j.nom} est chez lui.');
      phase = Phase.finDeTour;
      return;
    }

    if (etat.hypothequee) {
      _log('${c.nom} est hypothéquée : pas de loyer.');
      phase = Phase.finDeTour;
      return;
    }

    final proprietaire = joueurParId(etat.proprietaireId)!;
    final loyer = calculerLoyer(c.index);
    _log('${j.nom} paie $loyer € de loyer à ${proprietaire.nom}.');
    _payer(j, proprietaire, loyer);
    phase = Phase.finDeTour;
  }

  /// Loyer dû par celui qui s'arrête sur la case [indexCase].
  int calculerLoyer(int indexCase) {
    final c = plateau[indexCase];
    final etat = proprietes[indexCase]!;
    final proprietaireId = etat.proprietaireId;
    if (proprietaireId == null || etat.hypothequee) return 0;

    switch (c) {
      case CaseTerrain terrain:
        if (etat.constructions > 0) return terrain.loyers[etat.constructions];
        // Terrain nu : loyer doublé si le groupe est complet.
        final base = terrain.loyers[0];
        return possedeGroupeComplet(proprietaireId, terrain.groupe)
            ? base * 2
            : base;

      case CaseGare():
        final n = _compter<CaseGare>(proprietaireId);
        return CaseGare.loyerPour(n);

      case CaseCompagnie():
        final n = _compter<CaseCompagnie>(proprietaireId);
        return CaseCompagnie.loyerPour(n, dernierLancer?.total ?? 7);

      default:
        return 0;
    }
  }

  int _compter<T extends CasePlateau>(int proprietaireId) => plateau
      .whereType<T>()
      .where((c) => proprietes[c.index]!.proprietaireId == proprietaireId)
      .length;

  /// Transfert d'argent. [vers] à `null` = la banque.
  ///
  /// Version simplifiée : si le joueur ne peut pas payer, il fait faillite.
  /// L'étape suivante sera de le laisser hypothéquer ou vendre ses maisons.
  void _payer(Joueur de, Joueur? vers, int montant) {
    if (de.argent >= montant) {
      de.argent -= montant;
      if (vers != null) vers.argent += montant;
      return;
    }

    _log('${de.nom} ne peut pas payer $montant € : faillite.');
    if (vers != null) vers.argent += de.argent;
    de.argent = 0;
    de.enFaillite = true;

    // Ses propriétés reviennent au créancier (ou à la banque).
    for (final etat in proprietes.values) {
      if (etat.proprietaireId == de.id) {
        etat.proprietaireId = vers?.id;
        etat.constructions = 0;
      }
    }
  }

  void _envoyerEnPrison(Joueur j) {
    j.position = 10;
    j.enPrison = true;
    j.toursEnPrison = 0;
    _doublesConsecutifs = 0;
    _log('${j.nom} va en prison.');
    phase = Phase.finDeTour;
  }

  void _gererPrison(Lancer lancer) {
    final j = joueurCourant;

    if (lancer.estDouble) {
      j.enPrison = false;
      j.toursEnPrison = 0;
      _log('${j.nom} fait un double et sort de prison.');
      _avancer(j, lancer.total);
      _resoudreCase();
      return;
    }

    j.toursEnPrison++;
    if (j.toursEnPrison >= 3) {
      _log('${j.nom} paie 50 € et sort après 3 tours.');
      _payer(j, null, 50);
      j.enPrison = false;
      j.toursEnPrison = 0;
      _avancer(j, lancer.total);
      _resoudreCase();
      return;
    }

    _log('${j.nom} reste en prison (tour ${j.toursEnPrison}/3).');
    phase = Phase.finDeTour;
  }

  void _log(String message) => journal.add(message);

  void _exige(bool condition, String message) {
    if (!condition) throw StateError(message);
  }
}
