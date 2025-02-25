import 'package:flutter/material.dart';
import 'package:pencil/services/firebase_servicie.dart'; // Ensure this path is correct

class CrearCategorias extends StatefulWidget {
  const CrearCategorias({super.key});

  @override
  State<CrearCategorias> createState() => _CrearCategoriasState();
}

class _CrearCategoriasState extends State<CrearCategorias> {
  String _categoria = ''; // Variable para almacenar la nueva categoría

  // Getter y Setter para la categoría
  String get categoria => _categoria;
  set categoria(String value) {
    setState(() {
      _categoria = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nueva categoría'),
              onChanged: (value) => categoria = value, // Actualiza la categoría
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseService().crearCategoria(categoria);
                  // Provide user feedback on success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Categoría creada exitosamente')),
                  );
                  Navigator.pop(context); // Close the screen
                } catch (e) {
                  // Handle errors and provide user feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al crear la categoría: $e')),
                  );
                }
              },
              child: const Text('Nueva categoría'),
            ),
          ],
        ),
      ),
    );
  }
}
