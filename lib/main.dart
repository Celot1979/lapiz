import 'package:flutter/material.dart';
import 'package:pencil/pages/home_Pages.dart';
import 'package:pencil/pages/notas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PENCIL',
      routes: {
        "/":(context)=> const HomePage(),
        "/notas":(context)=> const Notas(),
      },
    );
  }
}