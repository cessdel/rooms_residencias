import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rooms_residencias/otra.dart';
import 'package:rooms_residencias/services/read.dart';

class PatientDetailScreen extends StatefulWidget {
  final String pacienteId;

  PatientDetailScreen(this.pacienteId);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final Values values = Values();

  Future<String> _getAllFieldValues() async {
    final nombre = await _getFieldValue('nombre');
    final habitacion = await _getFieldValue('habitacion');
    final genero = await _getFieldValue('genero');
    final fechaNacimiento = await _getFieldValue('fechaNacimiento');

    if (nombre == null || habitacion == null) {
      return 'Paciente no encontrado';
    }

    return 'Nombre del huésped: $nombre\nNúmero de habitación: $habitacion\nGénero: $genero\nFecha de Nacimiento: $fechaNacimiento';
  }

  Future<String> _getFieldValue(String field) async {
    final snapshot = await values.getPropertyValue(widget.pacienteId, field);
    return snapshot;
  }

  Future<Widget> _loadImage() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('fotos/${widget.pacienteId}.jpg');

    try {
      final url = await ref.getDownloadURL();
      return Image.network(url, width: 100, height: 100);
    } catch (e) {
      return Text('No se pudo cargar la imagen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Utiliza GestureDetector para detectar el toque
      onTap: () {
        // Navegar a otra ventana cuando se toque la tarjeta de detalles del paciente
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtraVentana(
              pacienteId: widget.pacienteId,
            ), // Reemplaza 'OtraVentana' con la ventana a la que deseas navegar
          ),
        );
      },
      child: Container(
        child: FutureBuilder(
          future: _getAllFieldValues(),
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder(
                          future: _loadImage(),
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
              );
            }
          },
        ),
      ),
    );
  }
}
