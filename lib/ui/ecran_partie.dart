import 'package:flutter/material.dart';

import '../moteur/joueur.dart';
import '../moteur/partie.dart';
import 'plateau_widget.dart';
import 'theme.dart';

class EcranPartie extends StatefulWidget {
  const EcranPartie({super.key});

  @override
  State<EcranPartie> createState() => _EcranPartieState();
}

class _EcranPartieState extends State<EcranPartie> {
  late Partie partie;

  @override
  void initState() {
    super.initState();
    _nouvellePartie();
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
  void _agir(void Function() action) => setState(action);

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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PlateauWidget(partie: partie),
                ),
              ),
            ),
          ),
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
          for (final j in partie.joueurs)
            Expanded(
              child: Opacity(
                opacity: j.enFaillite ? 0.4 : 1,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: couleursJoueurs[j.id % couleursJoueurs.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            j.nom,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: toile,
                              fontWeight: j.id == partie.joueurCourant.id
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            j.enFaillite ? 'Faillite' : '${j.argent} €',
                            style: const TextStyle(color: laiton, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BarreActions extends StatelessWidget {
  const _BarreActions({required this.partie, required this.agir});

  final Partie partie;
  final void Function(void Function()) agir;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
        child: switch (partie.phase) {
          Phase.attenteLancer => FilledButton(
              onPressed: () => agir(partie.lancerDes),
              child: const Text('Lancer les dés'),
            ),
          Phase.attenteAchat => Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => agir(partie.acheter),
                    child: Text('Acheter · ${partie.proprieteAVendre!.prix} €'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => agir(partie.refuserAchat),
                    child: const Text('Passer'),
                  ),
                ),
              ],
            ),
          Phase.finDeTour => OutlinedButton(
              onPressed: () => agir(partie.terminerTour),
              child: Text('Au tour de ${_prochainNom()}'),
            ),
          Phase.terminee => FilledButton(
              onPressed: null,
              child: Text(partie.joueursActifs.isEmpty
                  ? 'Partie terminée'
                  : '${partie.joueursActifs.first.nom} remporte la partie'),
            ),
        },
      ),
    );
  }

  String _prochainNom() {
    if (partie.dernierLancer?.estDouble == true) {
      return '${partie.joueurCourant.nom} (rejoue)';
    }
    var i = partie.joueurCourantIndex;
    do {
      i = (i + 1) % partie.joueurs.length;
    } while (partie.joueurs[i].enFaillite && i != partie.joueurCourantIndex);
    return partie.joueurs[i].nom;
  }
}
