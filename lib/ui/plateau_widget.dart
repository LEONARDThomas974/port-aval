import 'package:flutter/material.dart';

import '../moteur/partie.dart';
import 'case_widget.dart';
import 'geometrie_plateau.dart';
import 'theme.dart';

/// Le plateau carré : 40 cases sur le bord d'une grille 11x11, et au
/// centre les dés et le journal de la partie.
class PlateauWidget extends StatelessWidget {
  const PlateauWidget({super.key, required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraintes) {
        final taille = contraintes.maxWidth / 11;

        return Container(
          decoration: BoxDecoration(
            color: encreClaire,
            border: Border.all(color: laiton, width: 1.5),
          ),
          child: Stack(
            children: [
              Positioned(
                left: taille,
                top: taille,
                width: taille * 9,
                height: taille * 9,
                child: CentrePlateau(partie: partie),
              ),
              for (var i = 0; i < partie.plateau.length; i++)
                _positionne(i, taille),
            ],
          ),
        );
      },
    );
  }

  Widget _positionne(int index, double taille) {
    final pos = coordonneesCase(index);
    return Positioned(
      left: pos.colonne * taille,
      top: pos.ligne * taille,
      width: taille,
      height: taille,
      child: CaseWidget(partie: partie, index: index, taille: taille),
    );
  }
}

/// L'intérieur du plateau : les deux dés et les derniers événements.
class CentrePlateau extends StatelessWidget {
  const CentrePlateau({super.key, required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    final lignes = partie.journal.reversed.take(5).toList();
    final lancer = partie.dernierLancer;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lancer != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                De(valeur: lancer.de1),
                const SizedBox(width: 8),
                De(valeur: lancer.de2),
              ],
            ),
          const SizedBox(height: 14),
          for (var i = 0; i < lignes.length; i++)
            Text(
              lignes[i],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: i == 0 ? toile : toileFaible,
                fontSize: 10.5,
              ),
            ),
        ],
      ),
    );
  }
}

class De extends StatelessWidget {
  const De({super.key, required this.valeur});

  final int valeur;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: toile,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        '$valeur',
        style: const TextStyle(
          color: encre,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
