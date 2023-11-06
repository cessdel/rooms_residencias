// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rooms_residencias/services/auth.dart';

class Formulario extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  Formulario({super.key});

  Future<bool> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final userCredential =
          await _auth.signInWithEmailAndPassword(email, password);
      if (userCredential != null) {
        // Inicio de sesión exitoso, puedes realizar otras acciones aquí si es necesario.
        print('Inicio de sesión exitoso: ${userCredential.uid}');
        return true;
      } else {
        // Mostrar un mensaje de error al usuario si es necesario.
        print('Error al iniciar sesión');
        return false;
      }
    } catch (e) {
      // Manejar errores, por ejemplo, si las credenciales son incorrectas.
      print('Error al iniciar sesión: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ingrese sus credenciales:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
                iconColor: Colors.teal,
                labelText: 'Correo electrónico',
                labelStyle: TextStyle(color: Colors.teal),
                hintText: 'Ingresa correo electronico',
                icon: Icon(Icons.person)),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
                iconColor: Colors.teal,
                labelStyle: TextStyle(color: Colors.teal),
                hintText: 'Ingresa contraseña',
                labelText: 'Contraseña',
                icon: Icon(Icons.lock)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              if (await _login()) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Inicio de sesión exitoso'),
                      content: const Text('¡Has iniciado sesión con éxito!'),
                      actions: <Widget>[
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: (Colors.teal)),
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog.
                              Navigator.pushNamed(context,
                                  '/home'); // Navega a la página de inicio.
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error de inicio de sesión'),
                      content: const Text(
                          'No se pudo iniciar sesión. Por favor, verifica tus credenciales. O acude con el administrador'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Cierra el AlertDialog.
                          },
                        ),
                      ],
                    );
                  },
                );
              }

              // Agrega la lógica para procesar el formulario aquí
            },
            child: const Text('Enviar'),
          ),
          const SizedBox(
            height: 400,
          ),
        ],
      ),
    );
  }
}
