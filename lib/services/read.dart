import 'package:firebase_database/firebase_database.dart';

class Values {
  DatabaseReference _ref =
      FirebaseDatabase.instance.reference().child("pacientes");

  Future<String> getPropertyValue(String paciente, String nodo) async {
    final snapshot = await _ref.child(paciente).child(nodo).get();
    if (snapshot.exists) {
      return snapshot.value.toString();
    } else {
      return 'No data available';
    }
  }
}
