import 'package:flutter/material.dart';
import 'package:prueba/lista.dart'; // Importa el archivo donde tienes la clase PostList

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dio Example',
      home: PostList(), // Aquí llamas a PostList como el home de tu aplicación
    );
  }
}
