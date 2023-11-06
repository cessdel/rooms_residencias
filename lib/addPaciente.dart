import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rooms_residencias/room.dart';

class AddRoom extends StatefulWidget {
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Usuario _nuevoUsuario = Usuario(
      nombre: '',
      apellidos: '',
      fechaNacimiento: DateTime.now(),
      genero: 'Hombre',
      habitacion: '');

  // Controladores para los campos del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _habitacionController = TextEditingController();

  @override
  void dispose() {
    // Dispose de los controladores al finalizar.
    _nombreController.dispose();
    _apellidosController.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final fileName =
          'fotos/${_nuevoUsuario.id}.jpg'; // Nombre del archivo en Firebase Storage
      await cargarFoto(File(pickedFile.path), fileName);
    }
  }

  Future<bool> cargarFoto(File image, String fileName) async {
    try {
      final Reference ref = storage.ref().child(fileName);
      final UploadTask uploadTask = ref.putFile(image);

      await uploadTask.whenComplete(() {
        print('Subida de imagen completada.');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String url = await snapshot.ref.getDownloadURL();
      print('URL de descarga de la imagen: $url');
      return true;
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return false;
    }
  }

  Future<void> _guardarDatosEnFirebase() async {
    // Configura Firebase Realtime Database
    final database = FirebaseDatabase.instance;
    final dbRef = database.reference().child('pacientes');

    // Llena los datos del usuario a partir de los controladores
    _nuevoUsuario.nombre = _nombreController.text;
    _nuevoUsuario.apellidos = _apellidosController.text;
    _nuevoUsuario.habitacion = _habitacionController.text;
    _tomarFoto();

    // Llama al método guardarEnFirebase para guardar el usuario en Firebase.
    await _nuevoUsuario.guardarEnFirebase(dbRef);

    // Restablece los controladores
    _nombreController.clear();
    _apellidosController.clear();

    // Muestra un mensaje de confirmación
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content:
              Text('Usuario guardado en Firebase con ID: ${_nuevoUsuario.id}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Usuario'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _habitacionController,
                  decoration: const InputDecoration(
                      labelText: 'Numero de habitación',
                      labelStyle: TextStyle(color: Colors.teal)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Colors.teal)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                      labelText: 'Apellidos',
                      labelStyle: TextStyle(color: Colors.teal)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa los apellidos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          _nuevoUsuario.fechaNacimiento ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _nuevoUsuario.fechaNacimiento = selectedDate;
                        _fechaController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.teal,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_today, color: Colors.teal),
                        const SizedBox(width: 10.0),
                        Text(
                          _nuevoUsuario.fechaNacimiento == null
                              ? 'Selecciona una fecha de nacimiento'
                              : 'Fecha de Nacimiento: ${_fechaController.text}',
                          style: TextStyle(
                            color: _nuevoUsuario.fechaNacimiento == null
                                ? Colors.grey
                                : Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

// En el TextFormField, asigna el controlador _fechaController
                TextFormField(
                  controller: _fechaController,
                  enabled:
                      false, // Deshabilita la edición directa en el campo de texto.
                  decoration: const InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      labelStyle: TextStyle(color: Colors.teal)),
                ),

                DropdownButtonFormField<String>(
                  items: ['Hombre', 'Mujer'].map((genero) {
                    return DropdownMenuItem<String>(
                      value: genero,
                      child: Text(genero),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _nuevoUsuario.genero = value!;
                    });
                  },
                  value: _nuevoUsuario.genero,
                  decoration: const InputDecoration(
                      labelText: 'Género',
                      labelStyle: TextStyle(color: Colors.teal)),
                ),
                const SizedBox(height: 7),
                ElevatedButton(
                  onPressed: _guardarDatosEnFirebase,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // Cambia el color de fondo del botón.
                    onPrimary:
                        Colors.white, // Cambia el color del texto del botón.
                    padding: const EdgeInsets.all(
                        10.0), // Cambia el relleno del botón.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          45.0), // Cambia la forma del botón.
                    ),
                  ),
                  child: const Text(
                    'Guardar Usuario',
                    style: TextStyle(
                        fontSize: 15.0), // Cambia el estilo de texto del botón.
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
