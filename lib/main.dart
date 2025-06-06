import 'package:flutter/material.dart';
import 'screens/movie_list_screen.dart';

void main() {
  runApp(const AppPrincipal());
}

class AppPrincipal extends StatelessWidget {
  const AppPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TelaListaFilmes(),
    );
  }
}
