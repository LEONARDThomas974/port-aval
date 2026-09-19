/// Géométrie du plateau : où se place chaque case dans la grille 11x11.

/// Le plateau est une grille 11x11 dont seul le bord est occupé : 40 cases.
///
/// La case 0 (Départ) est en bas à droite. On avance vers la gauche le long
/// du bas, on remonte à gauche, on va vers la droite en haut, on redescend
/// à droite.
({int ligne, int colonne}) coordonneesCase(int index) {
  if (index <= 10) return (ligne: 10, colonne: 10 - index);
  if (index <= 20) return (ligne: 20 - index, colonne: 0);
  if (index <= 30) return (ligne: 0, colonne: index - 20);
  return (ligne: index - 30, colonne: 10);
}

/// De quel côté du plateau se trouve la case : ça détermine où poser le
/// bandeau de couleur, toujours tourné vers le centre.
enum CotePlateau { bas, gauche, haut, droite, coin }

CotePlateau cotePlateau(int index) {
  if (index == 0 || index == 10 || index == 20 || index == 30) {
    return CotePlateau.coin;
  }
  if (index < 10) return CotePlateau.bas;
  if (index < 20) return CotePlateau.gauche;
  if (index < 30) return CotePlateau.haut;
  return CotePlateau.droite;
}
