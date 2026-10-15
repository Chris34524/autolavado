import 'package:flutter/material.dart';

import 'package:autolavado_app/features/home/home_screen.dart';

void main() {
  runApp(const AutolavadoApp());
}

class AutolavadoApp extends StatelessWidget {
  const AutolavadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autolavado', // PROVISIONAL: nombre del negocio pendiente
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue, // PROVISIONAL: colores de marca pendientes
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}