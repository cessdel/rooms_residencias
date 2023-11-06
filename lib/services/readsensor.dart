import 'package:firebase_database/firebase_database.dart';

class ValuesSensores {
  DatabaseReference _ref = FirebaseDatabase.instance.reference();

  Future<String> getPropertyValue(String nodoPadre, String nodoHijo) async {
    final snapshot = await _ref.child(nodoPadre).child(nodoHijo).get();
    if (snapshot.exists) {
      return snapshot.value.toString();
    } else {
      return 'No data available';
    }
  }
}
