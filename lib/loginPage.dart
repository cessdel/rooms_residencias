import 'package:flutter/material.dart';
import 'package:rooms_residencias/services/formulario.dart';

class loginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('¡Bienvenido!'),
      //   backgroundColor:
      //       Colors.teal, // Cambia el color de fondo de la barra de navegación
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              child: Image.asset('assets/rooms.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Inicia sesión para comenzar!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          20), // Ajusta el radio según tu preferencia
                    ),
                  ),
                  builder: (context) {
                    return Formulario();
                  },
                );
                // Agrega la lógica para navegar a otras partes de tu aplicación
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Inicia sesión',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
