import 'package:flutter/material.dart';

class BotonDinamico extends StatelessWidget {
  final String nombreBoton;

  const BotonDinamico({super.key, required this.nombreBoton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Aquí puedes agregar la lógica que se ejecutará al presionar el botón
        print('Botón $nombreBoton presionado');
      },
      child: Text(nombreBoton),
    );
  }
}