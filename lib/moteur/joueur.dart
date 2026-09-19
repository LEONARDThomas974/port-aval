import 'dart:math';

/// Résultat d'un lancer de deux dés.
class Lancer {
  final int de1;
  final int de2;

  const Lancer(this.de1, this.de2);

  int get total => de1 + de2;
  bool get estDouble => de1 == de2;

  /// `random` est injectable : en test tu passes `Random(42)` pour avoir
  /// toujours la même partie, donc des tests reproductibles.
  factory Lancer.aleatoire(Random random) =>
      Lancer(random.nextInt(6) + 1, random.nextInt(6) + 1);

  @override
  String toString() => '$de1 + $de2 = $total${estDouble ? ' (double)' : ''}';
}

class Joueur {
  final int id;
  final String nom;

  /// Index de la case courante (0 à 39).
  int position;
  int argent;

  bool enPrison;
  int toursEnPrison;
  bool enFaillite;

  /// Cartes « sortie de prison » conservées.
  int cartesLiberation;

  Joueur({
    required this.id,
    required this.nom,
    this.position = 0,
    this.argent = 1500,
    this.enPrison = false,
    this.toursEnPrison = 0,
    this.enFaillite = false,
    this.cartesLiberation = 0,
  });

  @override
  String toString() => '$nom ($argent €, case $position)';
}

/// État d'une propriété sur le plateau, indexé par le numéro de case.
class EtatPropriete {
  /// `null` = la banque (personne ne l'a achetée).
  int? proprietaireId;

  /// 0 à 4 maisons, 5 = hôtel.
  int constructions;

  bool hypothequee;

  EtatPropriete({
    this.proprietaireId,
    this.constructions = 0,
    this.hypothequee = false,
  });

  bool get estLibre => proprietaireId == null;
  bool get aUnHotel => constructions == 5;
}
