import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rooms_residencias/services/read.dart';

class OtraVentana extends StatefulWidget {
  final String pacienteId;

  OtraVentana({required this.pacienteId});

  @override
  _OtraVentanaState createState() => _OtraVentanaState();
}

class _OtraVentanaState extends State<OtraVentana> {
  final Values values = Values();

  Future<String> _getAllFieldValues(String pacienteId) async {
    final nombre = await _getFieldValue(pacienteId, 'nombre');
    final habitacion = await _getFieldValue(pacienteId, 'habitacion');
    final genero = await _getFieldValue(pacienteId, 'genero');
    final fechaNacimiento = await _getFieldValue(pacienteId, 'fechaNacimiento');

    if (nombre == null || habitacion == null) {
      return 'Paciente no encontrado';
    }

    return 'Nombre del huésped: $nombre\nNúmero de habitación: $habitacion\nGénero: $genero\nFecha de Nacimiento: $fechaNacimiento';
  }

  Future<String> _getFieldValue(String pacienteId, String field) async {
    final snapshot = await values.getPropertyValue(pacienteId, field);
    return snapshot;
  }

  Future<Widget> _loadImage(String pacienteId) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('fotos/$pacienteId.jpg');

    try {
      final url = await ref.getDownloadURL();
      return Image.network(url, width: 100, height: 100);
    } catch (e) {
      return Text('No se pudo cargar la imagen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Paciente'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: _getAllFieldValues(widget.pacienteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final allValues = snapshot.data;

            if (allValues == 'Paciente no encontrado') {
              return Text(allValues!); // Muestra el mensaje de error
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Card(
                      color: Colors.green.shade50,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FutureBuilder(
                              future: _loadImage(widget.pacienteId),
                              builder: (context, imageSnapshot) {
                                if (imageSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  return imageSnapshot.data ?? Container();
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(allValues!),
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
        },
      ),
    );
  }
}
