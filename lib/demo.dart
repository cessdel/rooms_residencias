import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rooms_residencias/services/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String imageUrl =
//       '//proyecto-iot-f18db.appspot.com/fotos/DIF-NiJTEEwIHct5e1eAJxr.jpg';

//   @override
//   void initState() {
//     super.initState();
//     getImageUrl('fotos/imagen1.jpg').then((url) {
//       setState(() {
//         imageUrl = url!;
//       });
//     });
//   }

//   Future<String?> getImageUrl(String imagePath) async {
//     try {
//       final Reference storageReference =
//           FirebaseStorage.instance.ref(imagePath);
//       final String downloadURL = await storageReference.getDownloadURL();
//       return downloadURL;
//     } catch (e) {
//       print('Error al obtener la URL de la imagen: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Obtener URL de Imagen en Firebase Storage'),
//         ),
//         body: Center(
//           child: imageUrl != null
//               ? Image.network(
//                   imageUrl) // Muestra la imagen desde la URL de descarga.
//               : Text(
//                   'Cargando...'), // Muestra un mensaje mientras se obtiene la URL.
//         ),
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obtener URL de imagen de Firebase Storage',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Obtener la URL de la imagen
    storage
        .ref(
            'gs://proyecto-iot-f18db.appspot.com/fotos/DIF-NiJTEEwIHct5e1eAJxr.jpg')
        .getDownloadURL()
        .then((url) {
      setState(() {
        imageUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obtener URL de imagen de Firebase Storage'),
      ),
      body: Center(
        child: imageUrl != null
            ? Image.network(imageUrl)
            : CircularProgressIndicator(),
      ),
    );
  }
}
