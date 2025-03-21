import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prueba/screens/splash_screen.dart'; // Importa el SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pantallas Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Inicia con el SplashScreen
    );
  }
}