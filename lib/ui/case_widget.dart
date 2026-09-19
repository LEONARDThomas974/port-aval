import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';
import '../moteur/partie.dart';
import 'geometrie_plateau.dart';
import 'theme.dart';

/// Une case du plateau : bandeau de couleur tourné vers le centre, nom
/// abrégé, marqueur de propriétaire et pions présents.
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
    final epaisseur = taille * 0.22;

    final pions = partie.joueurs
        .where((j) => !j.enFaillite && j.position == index)
        .toList();

    return GestureDetector(
      onTap: () => _montrerFiche(context),
      child: Container(
        decoration: BoxDecoration(
          color: encre,
          border: Border.all(color: const Color(0xFF2C3F4E), width: 0.5),
        ),
        child: Stack(
          children: [
            if (c is CaseTerrain) _bande(c.groupe, epaisseur, cote),
            Padding(
              padding: _margeTexte(epaisseur, cote),
              child: Center(
                child: Text(
                  c.nom,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: toile,
                    fontSize: taille * 0.19,
                    height: 1.05,
                  ),
                ),
              ),
            ),
            if (proprietaire != null)
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: taille * 0.16,
                  height: taille * 0.16,
                  color: couleursJoueurs[
                      proprietaire.id % couleursJoueurs.length],
                ),
              ),
            if (pions.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: taille * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final j in pions)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: taille * 0.2,
                        height: taille * 0.2,
                        decoration: BoxDecoration(
                          color: couleursJoueurs[j.id % couleursJoueurs.length],
                          shape: BoxShape.circle,
                          border: Border.all(color: encre, width: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Le bandeau de couleur, posé sur le bord tourné vers le centre.
  Widget _bande(GroupeCouleur groupe, double epaisseur, CotePlateau cote) {
    final couleur = couleurGroupe(groupe);
    return switch (cote) {
      CotePlateau.bas => Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: epaisseur,
          child: ColoredBox(color: couleur),
        ),
      CotePlateau.haut => Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: epaisseur,
          child: ColoredBox(color: couleur),
        ),
      CotePlateau.gauche => Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          width: epaisseur,
          child: ColoredBox(color: couleur),
        ),
      CotePlateau.droite => Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          width: epaisseur,
          child: ColoredBox(color: couleur),
        ),
      CotePlateau.coin => const SizedBox.shrink(),
    };
  }

  EdgeInsets _margeTexte(double epaisseur, CotePlateau cote) => switch (cote) {
        CotePlateau.bas => EdgeInsets.only(top: epaisseur, bottom: 1),
        CotePlateau.haut => EdgeInsets.only(bottom: epaisseur, top: 1),
        CotePlateau.gauche => EdgeInsets.only(right: epaisseur, left: 1),
        CotePlateau.droite => EdgeInsets.only(left: epaisseur, right: 1),
        CotePlateau.coin => const EdgeInsets.all(1),
      };
  /// Au toucher, la fiche complète : les noms ne tiennent pas en entier
  /// dans une case de 30 pixels.
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
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
