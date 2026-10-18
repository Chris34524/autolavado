import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:autolavado_app/features/home/home_screen.dart';

Future<void> main() async {
  // Carga nombres de días y meses en español para DateFormat.
  await initializeDateFormatting('es_MX');
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
      // Español de México en toda la app, sin depender del idioma del celular.
      locale: const Locale('es', 'MX'),
      supportedLocales: const [Locale('es', 'MX')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
