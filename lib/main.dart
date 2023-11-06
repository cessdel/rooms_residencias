import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooms_residencias/barrainferior.dart';
import 'package:rooms_residencias/loginPage.dart';
import 'package:rooms_residencias/pacienteProvider.dart';
import 'package:rooms_residencias/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => PatientProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'rooms',
      initialRoute: '/home', // Ruta inicial
      routes: {
        '/': (context) => loginPage(), // Ruta de inicio
        '/home': (context) => barra(),
        '/menu': (context) => MyApp(), // Ejemplo de otra ruta
      },
    );
  }
}
