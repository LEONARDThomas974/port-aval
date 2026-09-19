import 'package:flutter/material.dart';

import 'ui/ecran_partie.dart';
import 'ui/theme.dart';

void main() => runApp(const AppPortAval());

class AppPortAval extends StatelessWidget {
  const AppPortAval({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Port-Aval',
      debugShowCheckedModeBanner: false,
      theme: themePortAval(),
      home: const EcranPartie(),
    );
  }
}
