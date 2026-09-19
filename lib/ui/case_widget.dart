import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';
import '../moteur/joueur.dart';
import '../moteur/partie.dart';
import 'geometrie_plateau.dart';
import 'theme.dart';

/// L'icône qui représente une case. `null` pour un terrain, qui affiche
/// son prix à la place.
IconData? iconeCase(CasePlateau c) => switch (c) {
      CaseTerrain() => null,
      CaseGare() => Icons.directions_railway,
      // La régie des eaux est la seule compagnie dont le nom parle d'eau.
      CaseCompagnie() =>
        c.nom.toLowerCase().contains('eau') ? Icons.water_drop : Icons.bolt,
      CaseCarte(paquet: TypePaquet.chance) => Icons.help_outline,
      CaseCarte(paquet: TypePaquet.coffre) => Icons.inventory_2_outlined,
      CaseTaxe() => Icons.account_balance,
      CaseDepart() => Icons.east,
      CasePrison() => Icons.lock_outline,
      CaseParcGratuit() => Icons.park_outlined,
      CaseAllezEnPrison() => Icons.gavel,
    };

Color couleurIcone(CasePlateau c) => switch (c) {
      CaseCarte(paquet: TypePaquet.chance) => const Color(0xFFD1608C),
      CaseCarte(paquet: TypePaquet.coffre) => const Color(0xFF2E8B57),
      CaseAllezEnPrison() || CasePrison() => const Color(0xFFC5342C),
      CaseTaxe() => const Color(0xFF7A4A2B),
      CaseDepart() => const Color(0xFF2E8B57),
      _ => encrePlateau,
    };

/// Une case du plateau : bandeau de couleur tourné vers le centre, prix ou
/// icône, maisons construites, marqueur de propriétaire et pions présents.
class CaseWidget extends StatelessWidget {
  const CaseWidget({
    super.key,
    required this.partie,
    required this.index,
    required this.taille,
  });

  final Partie partie;
  final int index;
  final double taille;

  @override
  Widget build(BuildContext context) {
    final c = partie.plateau[index];
    final etat = partie.proprietes[index];
    final proprietaire = partie.joueurParId(etat?.proprietaireId);
    final cote = cotePlateau(index);
    final epaisseur = taille * 0.26;

    final pions = partie.joueurs
        .where((j) => !j.enFaillite && j.position == index)
        .toList();

    final couleurProprio = proprietaire == null
        ? null
        : couleursJoueurs[proprietaire.id % couleursJoueurs.length];

    return GestureDetector(
      onTap: () => _montrerFiche(context),
      child: Container(
        decoration: BoxDecoration(
          color: couleurProprio == null
              ? parchemin
              : Color.alphaBlend(couleurProprio.withAlpha(30), parchemin),
          border: const Border(
            right: BorderSide(color: traitPlateau, width: 0.5),
            bottom: BorderSide(color: traitPlateau, width: 0.5),
          ),
        ),
        child: Stack(
          children: [
            if (c is CaseTerrain) _bande(c, etat, epaisseur, cote),
            Padding(
              padding: _margeTexte(epaisseur, cote),
              child: Center(child: _contenu(c)),
            ),
            if (couleurProprio != null) _lisereProprio(couleurProprio, cote),
            if (pions.isNotEmpty) _pions(pions),
          ],
        ),
      ),
    );
  }

  /// Au centre : le prix pour un terrain, une icône sinon.
  Widget _contenu(CasePlateau c) {
    final icone = iconeCase(c);
    if (icone != null) {
      return Icon(icone, size: taille * 0.42, color: couleurIcone(c));
    }
    return Text(
      '${(c as CaseTerrain).prix}',
      style: TextStyle(
        color: encrePlateau,
        fontSize: taille * 0.30,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  /// Le bandeau de couleur, sur le bord tourné vers le centre. Les maisons
  /// construites s'affichent dessus sous forme de petits carrés.
  Widget _bande(
    CaseTerrain c,
    EtatPropriete? etat,
    double epaisseur,
    CotePlateau cote,
  ) {
    final maisons = etat?.constructions ?? 0;
    final horizontal = cote == CotePlateau.bas || cote == CotePlateau.haut;

    final contenu = Container(
      color: couleurGroupe(c.groupe),
      alignment: Alignment.center,
      child: maisons == 0
          ? null
          : Flex(
              direction: horizontal ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < (maisons == 5 ? 1 : maisons); i++)
                  Container(
                    margin: const EdgeInsets.all(0.6),
                    width: taille * (maisons == 5 ? 0.18 : 0.1),
                    height: taille * (maisons == 5 ? 0.18 : 0.1),
                    color: maisons == 5
                        ? const Color(0xFFC5342C)
                        : const Color(0xFFF4EADA),
                  ),
              ],
            ),
    );

    return switch (cote) {
      CotePlateau.bas =>
        Positioned(left: 0, right: 0, top: 0, height: epaisseur, child: contenu),
      CotePlateau.haut => Positioned(
          left: 0, right: 0, bottom: 0, height: epaisseur, child: contenu),
      CotePlateau.gauche => Positioned(
          top: 0, bottom: 0, right: 0, width: epaisseur, child: contenu),
      CotePlateau.droite => Positioned(
          top: 0, bottom: 0, left: 0, width: epaisseur, child: contenu),
      CotePlateau.coin => const SizedBox.shrink(),
    };
  }

  /// Un liseré de la couleur du propriétaire, sur le bord extérieur.
  Widget _lisereProprio(Color couleur, CotePlateau cote) {
    final e = taille * 0.09;
    final barre = ColoredBox(color: couleur);
    return switch (cote) {
      CotePlateau.bas =>
        Positioned(left: 0, right: 0, bottom: 0, height: e, child: barre),
      CotePlateau.haut =>
        Positioned(left: 0, right: 0, top: 0, height: e, child: barre),
      CotePlateau.gauche =>
        Positioned(top: 0, bottom: 0, left: 0, width: e, child: barre),
      CotePlateau.droite =>
        Positioned(top: 0, bottom: 0, right: 0, width: e, child: barre),
      CotePlateau.coin => const SizedBox.shrink(),
    };
  }

  Widget _pions(List<Joueur> pions) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: taille * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final j in pions)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.8),
              width: taille * 0.28,
              height: taille * 0.28,
              decoration: BoxDecoration(
                color: couleursJoueurs[j.id % couleursJoueurs.length],
                shape: BoxShape.circle,
                border: Border.all(color: parchemin, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  EdgeInsets _margeTexte(double epaisseur, CotePlateau cote) => switch (cote) {
        CotePlateau.bas => EdgeInsets.only(top: epaisseur),
        CotePlateau.haut => EdgeInsets.only(bottom: epaisseur),
        CotePlateau.gauche => EdgeInsets.only(right: epaisseur),
        CotePlateau.droite => EdgeInsets.only(left: epaisseur),
        CotePlateau.coin => EdgeInsets.zero,
      };/// Au toucher, la fiche complète : le nom ne tient pas dans une case.
  void _montrerFiche(BuildContext context) {
    final c = partie.plateau[index];
    final etat = partie.proprietes[index];
    final proprietaire = partie.joueurParId(etat?.proprietaireId);

    final prix = switch (c) {
      CaseTerrain(:final prix) => prix,
      CaseGare(:final prix) => prix,
      CaseCompagnie(:final prix) => prix,
      _ => null,
    };

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: encreClaire,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (c is CaseTerrain)
                Container(
                  width: 56,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: couleurGroupe(c.groupe),
                ),
              Text(
                c.nom,
                style: const TextStyle(
                  color: toile,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                c is CaseTerrain ? c.groupe.libelle : 'Case $index',
                style: const TextStyle(color: toileDouce, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (prix == null)
                const Text(
                  'Cette case ne s\'achète pas.',
                  style: TextStyle(color: toileDouce),
                )
              else ...[
                LigneFiche(intitule: 'Prix', valeur: '$prix €'),
                LigneFiche(
                  intitule: 'Propriétaire',
                  valeur: proprietaire?.nom ?? 'Libre',
                ),
                if (proprietaire != null)
                  LigneFiche(
                    intitule: 'Loyer actuel',
                    valeur: '${partie.calculerLoyer(index)} €',
                  ),
                if (c is CaseTerrain)
                  LigneFiche(
                    intitule: 'Constructions',
                    valeur: switch (etat!.constructions) {
                      0 => 'aucune',
                      5 => 'hôtel',
                      final n => '$n maison${n > 1 ? 's' : ''}',
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Une ligne « intitulé … valeur » dans la fiche d'une case.
class LigneFiche extends StatelessWidget {
  const LigneFiche({
    super.key,
    required this.intitule,
    required this.valeur,
  });

  final String intitule;
  final String valeur;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(intitule, style: const TextStyle(color: toileDouce)),
          Text(valeur, style: const TextStyle(color: toile)),
        ],
      ),
    );
  }
}
