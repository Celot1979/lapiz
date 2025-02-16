import 'package:flutter/material.dart';

class NotaNueva extends StatefulWidget {
  const NotaNueva({super.key});

  @override
  State<NotaNueva> createState() => _NotaNuevaState();
}

class _NotaNuevaState extends State<NotaNueva> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Nota'),
      ),
      body: const Center(
        child: Text('Formulario para nueva nota'),
      ),
    );
  }
} 