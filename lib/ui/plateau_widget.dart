import 'package:flutter/material.dart';

import '../moteur/partie.dart';
import 'case_widget.dart';
import 'geometrie_plateau.dart';
import 'theme.dart';

/// Le plateau carré : 40 cases sur le bord d'une grille 11x11, et au
/// centre un cartouche sombre avec les dés et le journal.
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
            color: parchemin,
            border: Border.all(color: encrePlateau, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x88000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
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

/// L'intérieur du plateau : titre, dés et derniers événements.
class CentrePlateau extends StatelessWidget {
  const CentrePlateau({super.key, required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    final lignes = partie.journal.reversed.take(4).toList();
    final lancer = partie.dernierLancer;

    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: encreProfonde,
        border: Border.all(color: laiton, width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PORT-AVAL',
            style: TextStyle(
              color: laiton,
              fontSize: 15,
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
              shadows: const [Shadow(color: Color(0x66000000), blurRadius: 3)],
            ),
          ),
          const SizedBox(height: 14),
          if (lancer != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                De(valeur: lancer.de1),
                const SizedBox(width: 10),
                De(valeur: lancer.de2),
              ],
            )
          else
            const Text(
              'À vous de jouer',
              style: TextStyle(color: toileFaible, fontSize: 12),
            ),
          const SizedBox(height: 14),
          for (var i = 0; i < lignes.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                lignes[i],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: i == 0 ? toile : toileFaible,
                  fontSize: 10.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Un dé avec ses vraies faces, dessinées en points.
class De extends StatelessWidget {
  const De({super.key, required this.valeur});

  final int valeur;

  /// Pour chaque face, les emplacements occupés dans une grille 3x3.
  static const _faces = {
    1: [4],
    2: [0, 8],
    3: [0, 4, 8],
    4: [0, 2, 6, 8],
    5: [0, 2, 4, 6, 8],
    6: [0, 2, 3, 5, 6, 8],
  };

  @override
  Widget build(BuildContext context) {
    final points = _faces[valeur] ?? const <int>[];

    return Container(
      width: 34,
      height: 34,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: parchemin,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 9; i++)
            Center(
              child: points.contains(i)
                  ? Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: encrePlateau,
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
