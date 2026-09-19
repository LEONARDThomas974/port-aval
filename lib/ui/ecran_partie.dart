import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';
import '../moteur/joueur.dart';
import '../moteur/partie.dart';
import 'theme.dart';

const _hauteurCase = 66.0;

class EcranPartie extends StatefulWidget {
  const EcranPartie({super.key});

  @override
  State<EcranPartie> createState() => _EcranPartieState();
}

class _EcranPartieState extends State<EcranPartie> {
  late Partie partie;
  final _defilement = ScrollController();

  @override
  void initState() {
    super.initState();
    _nouvellePartie();
  }

  @override
  void dispose() {
    _defilement.dispose();
    super.dispose();
  }

  void _nouvellePartie() {
    partie = Partie(
      joueurs: [
        Joueur(id: 0, nom: 'Alice'),
        Joueur(id: 1, nom: 'Bruno'),
      ],
    );
  }

  /// Toutes les interactions passent par ici : on joue l'action sur le
  /// moteur, puis on redessine. L'écran ne connaît aucune règle.
  void _agir(void Function() action) {
    setState(action);
    _suivreLePion();
  }

  void _suivreLePion() {
    if (!_defilement.hasClients) return;
    final cible = (partie.joueurCourant.position * _hauteurCase)
        .clamp(0.0, _defilement.position.maxScrollExtent);
    _defilement.animateTo(
      cible,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Port-Aval'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recommencer',
            onPressed: () => _agir(_nouvellePartie),
          ),
        ],
      ),
      body: Column(
        children: [
          _BandeauJoueurs(partie: partie),
          Expanded(
            child: ListView.builder(
              controller: _defilement,
              itemExtent: _hauteurCase,
              itemCount: partie.plateau.length,
              itemBuilder: (context, i) =>
                  _LigneCase(partie: partie, index: i),
            ),
          ),
          _Journal(partie: partie),
          _BarreActions(partie: partie, agir: _agir),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BandeauJoueurs extends StatelessWidget {
  const _BandeauJoueurs({required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: encreClaire,
      child: Row(
        children: [
          for (final j in partie.joueurs)
            Expanded(
              child: Opacity(
                opacity: j.enFaillite ? 0.4 : 1,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: couleursJoueurs[j.id % couleursJoueurs.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            j.nom,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: toile,
                              fontWeight: j.id == partie.joueurCourant.id
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            j.enFaillite ? 'Faillite' : '${j.argent} €',
                            style: const TextStyle(color: laiton, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------

class _LigneCase extends StatelessWidget {
  const _LigneCase({required this.partie, required this.index});

  final Partie partie;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = partie.plateau[index];
    final etat = partie.proprietes[index];
    final proprietaire = partie.joueurParId(etat?.proprietaireId);
    final estCaseCourante = partie.joueurCourant.position == index;

    return Container(
      decoration: BoxDecoration(
        color: estCaseCourante ? encreClaire : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E2E3A)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 40,
            color: c is CaseTerrain ? couleurGroupe(c.groupe) : encreClaire,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.nom,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: toile, fontSize: 15),
                ),
                Text(
                  _sousTitre(c, proprietaire, etat),
                  style: const TextStyle(color: toileDouce, fontSize: 12),
                ),
              ],
            ),
          ),
          for (final j in partie.joueurs)
            if (!j.enFaillite && j.position == index)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: couleursJoueurs[j.id % couleursJoueurs.length],
                    shape: BoxShape.circle,
                    border: Border.all(color: encre, width: 2),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _sousTitre(CasePlateau c, Joueur? proprietaire, EtatPropriete? etat) {
    if (c is! CaseAchetable) return '';
    if (proprietaire == null) return 'Libre · ${c.prix} €';

    final maisons = etat!.constructions;
    final construction = switch (maisons) {
      0 => '',
      5 => ' · hôtel',
      _ => ' · $maisons maison${maisons > 1 ? 's' : ''}',
    };
    return '${proprietaire.nom}$construction · '
        'loyer ${partie.calculerLoyer(index)} €';
  }
}

// ---------------------------------------------------------------------------

class _Journal extends StatelessWidget {
  const _Journal({required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    final lignes = partie.journal.reversed.take(3).toList();

    return Container(
      width: double.infinity,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: encreClaire,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lignes.length; i++)
            Text(
              lignes[i],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: i == 0 ? toile : toileFaible,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BarreActions extends StatelessWidget {
  const _BarreActions({required this.partie, required this.agir});

  final Partie partie;
  final void Function(void Function()) agir;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: switch (partie.phase) {
          Phase.attenteLancer => FilledButton(
              onPressed: () => agir(partie.lancerDes),
              child: Text(partie.dernierLancer == null
                  ? 'Lancer les dés'
                  : 'Lancer les dés · dernier ${partie.dernierLancer!.total}'),
            ),
          Phase.attenteAchat => Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => agir(partie.acheter),
                    child: Text('Acheter · '
                        '${partie.proprieteAVendre!.prix} €'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => agir(partie.refuserAchat),
                    child: const Text('Passer'),
                  ),
                ),
              ],
            ),
          Phase.finDeTour => OutlinedButton(
              onPressed: () => agir(partie.terminerTour),
              child: Text('Au tour de ${_prochainNom()}'),
            ),
          Phase.terminee => FilledButton(
              onPressed: null,
              child: Text(partie.joueursActifs.isEmpty
                  ? 'Partie terminée'
                  : '${partie.joueursActifs.first.nom} remporte la partie'),
            ),
        },
      ),
    );
  }

  String _prochainNom() {
    if (partie.dernierLancer?.estDouble == true) {
      return '${partie.joueurCourant.nom} (rejoue)';
    }
    var i = partie.joueurCourantIndex;
    do {
      i = (i + 1) % partie.joueurs.length;
    } while (partie.joueurs[i].enFaillite && i != partie.joueurCourantIndex);
    return partie.joueurs[i].nom;
  }
}
