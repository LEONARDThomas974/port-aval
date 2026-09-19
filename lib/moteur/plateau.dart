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
    groupe: Groupe
