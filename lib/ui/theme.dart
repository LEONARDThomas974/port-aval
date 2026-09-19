import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';

// ---------------------------------------------------------------------------
// Palette
// ---------------------------------------------------------------------------
// L'application est sombre, le plateau est clair : c'est ce contraste qui
// fait ressortir le plateau, et du texte foncé sur fond crème reste lisible
// à 8 pixels, ce qui n'était pas le cas de l'inverse.

/// Fonds sombres de l'application.
const encre = Color(0xFF13202A);
const encreClaire = Color(0xFF1E3140);
const encreProfonde = Color(0xFF0C161E);

/// Textes sur fond sombre.
const toile = Color(0xFFEDE6D8);
const toileDouce = Color(0x8FEDE6D8);
const toileFaible = Color(0x59EDE6D8);

/// Accents.
const laiton = Color(0xFFD0A040);
const corail = Color(0xFFB4533A);

/// Le plateau lui-même.
const parchemin = Color(0xFFF4EADA);
const parcheminOmbre = Color(0xFFDFD1B8);
const traitPlateau = Color(0xFFBFAE90);
const encrePlateau = Color(0xFF2A2018);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        foregroundColor: toile,
        side: const BorderSide(color: encreClaire, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Couleurs de jeu
// ---------------------------------------------------------------------------

/// Les bandeaux des familles de terrains, choisis pour rester distincts
/// les uns des autres sur fond crème.
Color couleurGroupe(GroupeCouleur groupe) => switch (groupe) {
      GroupeCouleur.marron => const Color(0xFF7A4A2B),
      GroupeCouleur.cyan => const Color(0xFF4EA5C9),
      GroupeCouleur.rose => const Color(0xFFD1608C),
      GroupeCouleur.orange => const Color(0xFFE38230),
      GroupeCouleur.rouge => const Color(0xFFC5342C),
      GroupeCouleur.jaune => const Color(0xFFEFC13A),
      GroupeCouleur.vert => const Color(0xFF2E8B57),
      GroupeCouleur.bleu => const Color(0xFF2C4F9C),
    };

/// Une couleur par joueur. Volontairement très éloignées les unes des
/// autres, y compris pour un daltonien : rouge, sarcelle, or, violet.
const couleursJoueurs = [
  Color(0xFFD1453F),
  Color(0xFF2B8C9E),
  Color(0xFFDFA32C),
  Color(0xFF6B54A6),
];

/// Les jetons des joueurs, sur le thème portuaire.
const iconesJoueurs = [
  Icons.anchor,
  Icons.sailing,
  Icons.explore,
  Icons.diamond_outlined,
];
