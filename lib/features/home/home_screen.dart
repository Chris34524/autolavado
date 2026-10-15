import 'package:flutter/material.dart';

import 'package:autolavado_app/features/booking/screens/service_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autolavado'), // PROVISIONAL
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_car_wash, size: 96),
            const SizedBox(height: 24),
            const Text(
              'Tu auto limpio, fácil y rápido',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Reserva tu lavado en minutos y elige el horario que mejor te acomode.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceSelectionScreen(),
                  ),
                );
              },
              child: const Text('Reservar lavado'),
            ),
          ],
        ),
      ),
    );
  }
}