/// Les 40 cases du plateau.
///
/// IMPORTANT : ce fichier ne doit JAMAIS importer Flutter.
/// C'est du Dart pur, testable en une seconde.

/// Les 8 familles de terrains.
enum GroupeCouleur {
  marron('Marron'),
  cyan('Cyan'),
  rose('Rose'),
  orange('Orange'),
  rouge('Rouge'),
  jaune('Jaune'),
  vert('Vert'),
  bleu('Bleu');

  final String libelle;
  const GroupeCouleur(this.libelle);
}

/// Les deux paquets de cartes.
enum TypePaquet { chance, coffre }

/// Case de base. `sealed` = la liste des sous-types est fermée,
/// donc le compilateur t'obligera à tous les traiter dans un `switch`.
sealed class CasePlateau {
  final int index;
  final String nom;

  const CasePlateau({required this.index, required this.nom});

  @override
  String toString() => '[$index] $nom';
}

/// Tout ce qui peut être acheté et générer un loyer.
abstract interface class CaseAchetable {
  int get index;
  String get nom;
  int get prix;

  /// Valeur récupérée en hypothéquant (la moitié du prix, arrondi bas).
  int get valeurHypotheque;
}

// ---------------------------------------------------------------------------
// Cases achetables
// ---------------------------------------------------------------------------

class CaseTerrain extends CasePlateau implements CaseAchetable {
  final GroupeCouleur groupe;

  @override
  final int prix;

  /// Coût d'une maison (et d'un hôtel) sur ce terrain.
  final int prixConstruction;

  /// 6 valeurs : [terrain nu, 1 maison, 2, 3, 4, hôtel].
  final List<int> loyers;

  const CaseTerrain({
    required super.index,
    required super.nom,
    required this.groupe,
    required this.prix,
    required this.prixConstruction,
    required this.loyers,
  });

  @override
  int get valeurHypotheque => prix ~/ 2;
}

class CaseGare extends CasePlateau implements CaseAchetable {
  @override
  final int prix;

  const CaseGare({
    required super.index,
    required super.nom,
    this.prix = 200,
  });

  @override
  int get valeurHypotheque => prix ~/ 2;

  /// 25 / 50 / 100 / 200 selon le nombre de gares du même propriétaire.
  static int loyerPour(int nbGares) => 25 * (1 << (nbGares - 1));
}

class CaseCompagnie extends CasePlateau implements CaseAchetable {
  @override
  final int prix;

  const CaseCompagnie({
    required super.index,
    required super.nom,
    this.prix = 150,
  });

  @override
  int get valeurHypotheque => prix ~/ 2;

  /// 4x le lancer si le propriétaire en a une, 10x s'il a les deux.
  static int loyerPour(int nbCompagnies, int totalDes) =>
      (nbCompagnies >= 2 ? 10 : 4) * totalDes;
}

// ---------------------------------------------------------------------------
// Cases non achetables
// ---------------------------------------------------------------------------

class CaseDepart extends CasePlateau {
  final int prime;
  const CaseDepart({required super.index, required super.nom, this.prime = 200});
}

class CaseTaxe extends CasePlateau {
  final int montant;
  const CaseTaxe({
    required super.index,
    required super.nom,
    required this.montant,
  });
}

class CaseCarte extends CasePlateau {
  final TypePaquet paquet;
  const CaseCarte({
    required super.index,
    required super.nom,
    required this.paquet,
  });
}

/// La case prison quand on s'y arrête sans y être envoyé : simple visite.
class CasePrison extends CasePlateau {
  const CasePrison({required super.index, required super.nom});
}

class CaseAllezEnPrison extends CasePlateau {
  const CaseAllezEnPrison({required super.index, required super.nom});
}

class CaseParcGratuit extends CasePlateau {
  const CaseParcGratuit({required super.index, required super.nom});
}
