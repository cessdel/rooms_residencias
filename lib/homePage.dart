import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rooms_residencias/addRoom.dart';
import 'package:rooms_residencias/pacienteProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _patientIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      // Envuelve tu contenido con un Scaffold
      appBar: AppBar(
        backgroundColor: Colors.teal,
        // Define el AppBar aquí
        title: Text('Habitaciones'), // Cambia el título según tus necesidades
      ),
      body: Column(
        children: [
          Text(
            '¡Bienvenido!',
            style: TextStyle(
              fontSize: 20, // Tamaño de fuente
              fontWeight:
                  FontWeight.bold, // Peso de fuente (por ejemplo, negrita)
              color: Colors.teal, // Color del texto
              // Otros atributos de estilo, como fontFamily, letterSpacing, etc.
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Ingresar ID de Paciente'),
                    content: TextField(
                      controller: _patientIdController,
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          String pacienteId = _patientIdController.text;
                          patientProvider.addPatient(pacienteId);
                          Navigator.of(context).pop();
                        },
                        child: Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.teal, // Color de fondo del botón
              onPrimary: Colors.white, // Color del texto del botón
              padding: EdgeInsets.all(16), // Padding del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    15), // Forma del botón (borde redondeado)
              ),
            ),
            child: Text(
              'Visualiza mas habitaciones',
              style: TextStyle(
                fontSize: 16, // Tamaño del texto del botón
              ),
            ),
          ),
          Expanded(
            child: Consumer<PatientProvider>(
              builder: (context, provider, child) {
                return ListView(
                  children: provider.patientIds
                      .map((pacienteId) => PatientDetailScreen(pacienteId))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
