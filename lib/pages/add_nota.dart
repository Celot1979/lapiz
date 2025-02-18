import 'package:flutter/material.dart';
import 'package:pencil/services/firebase_servicie.dart';
 // Asegúrate de importar el servicio de Firebase

class AddNota extends StatefulWidget {
  @override
  _AddNotaState createState() => _AddNotaState();
}

class _AddNotaState extends State<AddNota> {
  String _clasificacion = '';
  String _titulo = '';
  String _campo = '';

  // Getters y Setters
  String get clasificacion => _clasificacion;
  set clasificacion(String value) {
    setState(() {
      _clasificacion = value;
    });
  }

  String get titulo => _titulo;
  set titulo(String value) {
    setState(() {
      _titulo = value;
    });
  }

  String get campo => _campo;
  set campo(String value) {
    setState(() {
      _campo = value;
    });
  }

  void _guardarNota() async {
    // Crear un mapa con la información de la nota
    Map<String, dynamic> nota = {
      'clasificacion': clasificacion,
      'titulo': titulo,
      'campo': campo, // Asumiendo que 'campo' es el contenido de la nota
    };

    // Llama al método addNota de firebase_service.dart
    await FirebaseService().addNota(nota);
    
    // Limpiar los campos de texto
    clasificacion = '';
    titulo = '';
    campo = '';

    // Navegar de regreso a la página notas.dart
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Clasificación'),
              onChanged: (value) => clasificacion = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Título'),
              onChanged: (value) => titulo = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Campo'),
              onChanged: (value) => campo = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarNota, // Llama al método para guardar la nota
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
