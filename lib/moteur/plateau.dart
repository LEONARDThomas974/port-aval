import 'case_plateau.dart';

/// Le plateau de « Port-Aval », une ville portuaire imaginaire.
///
/// Noms, prix et thème sont originaux : tu peux publier sans souci.
/// Les valeurs de loyer sont un point de départ équilibré, ajuste-les
/// librement quand tu feras tes tests de jeu.
const List<CasePlateau> plateauPortAval = [
  CaseDepart(index: 0, nom: 'Départ'),

  CaseTerrain(
    index: 1,
    nom: 'Rue des Tanneurs',
    groupe: GroupeCouleur.marron,
    prix: 60,
    prixConstruction: 50,
    loyers: [2, 10, 30, 90, 160, 250],
  ),
  CaseCarte(index: 2, nom: 'Coffre de la ville', paquet: TypePaquet.coffre),
  CaseTerrain(
    index: 3,
    nom: 'Impasse du Puits',
    groupe: GroupeCouleur.marron,
    prix: 60,
    prixConstruction: 50,
    loyers: [4, 20, 60, 180, 320, 450],
  ),
  CaseTaxe(index: 4, nom: 'Taxe portuaire', montant: 200),
  CaseGare(index: 5, nom: 'Gare du Vieux-Port'),

  CaseTerrain(
    index: 6,
    nom: 'Quai des Lanternes',
    groupe: GroupeCouleur.cyan,
    prix: 100,
    prixConstruction: 50,
    loyers: [6, 30, 90, 270, 400, 550],
  ),
  CaseCarte(index: 7, nom: 'Coup du sort', paquet: TypePaquet.chance),
  CaseTerrain(
    index: 8,
    nom: 'Rue Verdet',
    groupe: GroupeCouleur.cyan,
    prix: 100,
    prixConstruction: 50,
    loyers: [6, 30, 90, 270, 400, 550],
  ),
  CaseTerrain(
    index: 9,
    nom: 'Allée des Brumes',
    groupe: GroupeCouleur.cyan,
    prix: 120,
    prixConstruction: 50,
    loyers: [8, 40, 100, 300, 450, 600],
  ),

  CasePrison(index: 10, nom: 'Prison (simple visite)'),

  CaseTerrain(
    index: 11,
    nom: 'Boulevard Saint-Elme',
    groupe: GroupeCouleur.rose,
    prix: 140,
    prixConstruction: 100,
    loyers: [10, 50, 150, 450, 625, 750],
  ),
  CaseCompagnie(index: 12, nom: 'Centrale électrique'),
  CaseTerrain(
    index: 13,
    nom: 'Rue de la Corderie',
    groupe: GroupeCouleur.rose,
    prix: 140,
    prixConstruction: 100,
    loyers: [10, 50, 150, 450, 625, 750],
  ),
  CaseTerrain(
    index: 14,
    nom: 'Place Fabre',
    groupe: GroupeCouleur.rose,
    prix: 160,
    prixConstruction: 100,
    loyers: [12, 60, 180, 500, 700, 900],
  ),
  CaseGare(index: 15, nom: 'Gare Centrale'),

  CaseTerrain(
    index: 16,
    nom: 'Rue des Orfèvres',
    groupe: GroupeCouleur.orange,
    prix: 180,
    prixConstruction: 100,
    loyers: [14, 70, 200, 550, 750, 950],
  ),
  CaseCarte(index: 17, nom: 'Coffre de la ville', paquet: TypePaquet.coffre),
  CaseTerrain(
    index: 18,
    nom: 'Passage Mirabeau',
    groupe: GroupeCouleur.orange,
    prix: 180,
    prixConstruction: 100,
    loyers: [14, 70, 200, 550, 750, 950],
  ),
  CaseTerrain(
    index: 19,
    nom: 'Avenue du Phare',
    groupe: GroupeCouleur.orange,
    prix: 200,
    prixConstruction: 100,
    loyers: [16, 80, 220, 600, 800, 1000],
  ),

  CaseParcGratuit(index: 20, nom: 'Esplanade libre'),

  CaseTerrain(
    index: 21,
    nom: 'Rue Bellerive',
    groupe: GroupeCouleur.rouge,
    prix: 220,
    prixConstruction: 150,
    loyers: [18, 90, 250, 700, 875, 1050],
  ),
  CaseCarte(index: 22, nom: 'Coup du sort', paquet: TypePaquet.chance),
  CaseTerrain(
    index: 23,
    nom: 'Cours Tissot',
    groupe: GroupeCouleur.rouge,
    prix: 220,
    prixConstruction: 150,
    loyers: [18, 90, 250, 700, 875, 1050],
  ),
  CaseTerrain(
    index: 24,
    nom: 'Avenue des Arènes',
    groupe: GroupeCouleur.rouge,
    prix: 240,
    prixConstruction: 150,
    loyers: [20, 100, 300, 750, 925, 1100],
  ),
  CaseGare(index: 25, nom: 'Gare des Docks'),

  CaseTerrain(
    index: 26,
    nom: 'Boulevard Malmont',
    groupe: GroupeCouleur.jaune,
    prix: 260,
    prixConstruction: 150,
    loyers: [22, 110, 330, 800, 975, 1150],
  ),
  CaseTerrain(
    index: 27,
    nom: 'Rue du Cygne',
    groupe: GroupeCouleur.jaune,
    prix: 260,
    prixConstruction: 150,
    loyers: [22, 110, 330, 800, 975, 1150],
  ),
  CaseCompagnie(index: 28, nom: 'Régie des eaux'),
  CaseTerrain(
    index: 29,
    nom: 'Esplanade Caron',
    groupe: GroupeCouleur.jaune,
    prix: 280,
    prixConstruction: 150,
    loyers: [24, 120, 360, 850, 1025, 1200],
  ),

  CaseAllezEnPrison(index: 30, nom: 'Allez en prison'),

  CaseTerrain(
    index: 31,
    nom: 'Avenue Morvan',
    groupe: GroupeCouleur.vert,
    prix: 300,
    prixConstruction: 200,
    loyers: [26, 130, 390, 900, 1100, 1275],
  ),
  CaseTerrain(
    index: 32,
    nom: 'Rue des Alizés',
    groupe: GroupeCouleur.vert,
    prix: 300,
    prixConstruction: 200,
    loyers: [26, 130, 390, 900, 1100, 1275],
  ),
  CaseCarte(index: 33, nom: 'Coffre de la ville', paquet: TypePaquet.coffre),
  CaseTerrain(
    index: 34,
    nom: 'Promenade du Belvédère',
    groupe: GroupeCouleur.vert,
    prix: 320,
    prixConstruction: 200,
    loyers: [28, 150, 450, 1000, 1200, 1400],
  ),
  CaseGare(index: 35, nom: 'Gare du Belvédère'),

  CaseCarte(index: 36, nom: 'Coup du sort', paquet: TypePaquet.chance),
  CaseTerrain(
    index: 37,
    nom: "Quai d'Honneur",
    groupe: GroupeCouleur.bleu,
    prix: 350,
    prixConstruction: 200,
    loyers: [35, 175, 500, 1100, 1300, 1500],
  ),
  CaseTaxe(index: 38, nom: 'Taxe de luxe', montant: 100),
  CaseTerrain(
    index: 39,
    nom: 'Avenue Aurore',
    groupe: GroupeCouleur.bleu,
    prix: 400,
    prixConstruction: 200,
    loyers: [50, 200, 600, 1400, 1700, 2000],
  ),
];

/// Combien de terrains dans chaque famille (utile pour savoir si
/// un joueur possède le groupe complet).
final Map<GroupeCouleur, int> taillesGroupes = {
  for (final g in GroupeCouleur.values)
    g: plateauPortAval
        .whereType<CaseTerrain>()
        .where((t) => t.groupe == g)
        .length,
};
