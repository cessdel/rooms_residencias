import 'package:flutter/material.dart';

class PatientProvider with ChangeNotifier {
  List<String> _patientIds = [];

  List<String> get patientIds => _patientIds;

  void addPatient(String id) {
    _patientIds.add(id);
    notifyListeners();
  }
}
