import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';

/// Palette tirée du thème portuaire : encre de nuit, laiton d'instruments
/// de marine, toile écrue des voiles.
const encre = Color(0xFF16242F);
const encreClaire = Color(0xFF223543);
const toile = Color(0xFFEDE6D8);
const laiton = Color(0xFFC08A2C);
const corail = Color(0xFFB4533A);

ThemeData themePortAval() {
  const schema = ColorScheme.dark(
    primary: laiton,
    onPrimary: encre,
    secondary: corail,
    onSecondary: toile,
    surface: encre,
    onSurface: toile,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: schema,
    scaffoldBackgroundColor: encre,
    appBarTheme: const AppBarTheme(
      backgroundColor: encre,
      foregroundColor: toile,
      centerTitle: false,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        foregroundColor: toile,
        side: const BorderSide(color: encreClaire, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}

/// La pastille de couleur d'un groupe de terrains.
Color couleurGroupe(GroupeCouleur groupe) => switch (groupe) {
      GroupeCouleur.marron => const Color(0xFF6B4A32),
      GroupeCouleur.cyan => const Color(0xFF6FA8BF),
      GroupeCouleur.rose => const Color(0xFFC1738F),
      GroupeCouleur.orange => const Color(0xFFD1823A),
      GroupeCouleur.rouge => const Color(0xFFB03A30),
      GroupeCouleur.jaune => const Color(0xFFD9B23C),
      GroupeCouleur.vert => const Color(0xFF3E7D55),
      GroupeCouleur.bleu => const Color(0xFF3B5E9B),
    };

/// Une couleur par joueur, pour les pions.
const couleursJoueurs = [
  Color(0xFFE0C068),
  Color(0xFF7FB2A6),
  Color(0xFFCB7B5C),
  Color(0xFF9B8FC0),
];

/// Déclinaisons atténuées de la toile, pour le texte secondaire.
/// Définies en constantes plutôt que via `withOpacity` / `withValues`,
/// dont l'API a changé entre les versions de Flutter.
const toileDouce = Color(0x8FEDE6D8);
const toileFaible = Color(0x59EDE6D8);
