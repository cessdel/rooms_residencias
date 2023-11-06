import 'package:flutter/material.dart';
import 'package:rooms_residencias/services/readsensor.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  final ValuesSensores values = ValuesSensores();
  String luzValue = '';
  String temperaturaValue = '';
  String humedadValue = '';
  String sonidoValue = '';

  Future<void> _loadSensorData() async {
    luzValue = await _getFieldValue('luz');
    temperaturaValue = await _getFieldValue('temperatura');
    humedadValue = await _getFieldValue('humedad');
    sonidoValue = await _getFieldValue('sonido');
  }

  Future<String> _getFieldValue(String field) async {
    final snapshot = await values.getPropertyValue('sensores', field);
    return snapshot ?? 'No data available';
  }

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Sensores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              SensorValueWidget(sensorName: 'Luz', value: luzValue),
              SensorValueWidget(
                  sensorName: 'Temperatura', value: temperaturaValue),
              SensorValueWidget(sensorName: 'Humedad', value: humedadValue),
              SensorValueWidget(sensorName: 'Sonido', value: sonidoValue),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorValueWidget extends StatelessWidget {
  final String sensorName;
  final String value;

  SensorValueWidget({required this.sensorName, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$sensorName: $value'),
    );
  }
}
