import 'package:flutter/material.dart';

import '../moteur/case_plateau.dart';
import '../moteur/joueur.dart';
import '../moteur/partie.dart';
import 'theme.dart';

const _hauteurCase = 66.0;

class EcranPartie extends StatefulWidget {
  const EcranPartie({super.key});

  @override
  State<EcranPartie> createState() => _EcranPartieState();
}

class _EcranPartieState extends State<EcranPartie> {
  late Partie partie;
  final _defilement = ScrollController();

  @override
  void initState() {
    super.initState();
    _nouvellePartie();
  }

  @override
  void dispose() {
    _defilement.dispose();
    super.dispose();
  }

  void _nouvellePartie() {
    partie = Partie(
      joueurs: [
        Joueur(id: 0, nom: 'Alice'),
        Joueur(id: 1, nom: 'Bruno'),
      ],
    );
  }

  /// Toutes les interactions passent par ici : on joue l'action sur le
  /// moteur, puis on redessine. L'écran ne connaît aucune règle.
  void _agir(void Function() action) {
    setState(action);
    _suivreLePion();
  }

  void _suivreLePion() {
    if (!_defilement.hasClients) return;
    final cible = (partie.joueurCourant.position * _hauteurCase)
        .clamp(0.0, _defilement.position.maxScrollExtent);
    _defilement.animateTo(
      cible,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Port-Aval'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recommencer',
            onPressed: () => _agir(_nouvellePartie),
          ),
        ],
      ),
      body: Column(
        children: [
          _BandeauJoueurs(partie: partie),
          Expanded(
            child: ListView.builder(
              controller: _defilement,
              itemExtent: _hauteurCase,
              itemCount: partie.plateau.length,
              itemBuilder: (context, i) =>
                  _LigneCase(partie: partie, index: i),
            ),
          ),
          _Journal(partie: partie),
          _BarreActions(partie: partie, agir: _agir),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BandeauJoueurs extends StatelessWidget {
  const _BandeauJoueurs({required this.partie});

  final Partie partie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: encreClaire,
      child: Row(
        children: [
          for (f
