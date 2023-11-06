import 'package:firebase_database/firebase_database.dart';

class Usuario {
  late String id; // Ya no se inicializa con un valor vacío.
  String nombre;
  String apellidos;
  DateTime? fechaNacimiento;
  String genero;
  String habitacion;

  Usuario(
      {required this.nombre,
      required this.apellidos,
      this.fechaNacimiento,
      required this.genero,
      required this.habitacion});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento!.toIso8601String(),
      'genero': genero,
      'habitacion': habitacion
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
        nombre: map['nombre'],
        apellidos: map['apellidos'],
        fechaNacimiento: DateTime.parse(map['fechaNacimiento']),
        genero: map['genero'],
        habitacion: map['habitacion']);
  }

  Future<void> guardarEnFirebase(DatabaseReference db) async {
    // Generar una nueva ID de nodo automáticamente con push().
    final newChild = db.push();

    // Obtener la clave generada por Firebase.
    final newKey = newChild.key;

    // Establecer la ID del paciente con el prefijo "DIF-" y la clave generada.
    id = 'DIF$newKey';

    // Crear un nuevo nodo en Firebase con la ID completa.
    await db.child(id).set(toMap());
  }
}
