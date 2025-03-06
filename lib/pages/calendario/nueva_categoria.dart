import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CrearCategorias extends StatefulWidget {
  const CrearCategorias({Key? key}) : super(key: key);

  @override
  State<CrearCategorias> createState() => _CrearCategoriasState();
}

class _CrearCategoriasState extends State<CrearCategorias> {
  String _categoria = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _guardarCategoria() async {
    if (_formKey.currentState!.validate()) {
      try {
        final prefs = await SharedPreferences.getInstance();
        
        // Obtener categorías existentes o crear lista vacía
        List<String> categorias = prefs.getStringList('categorias_personalizadas') ?? [];
        
        // Agregar nueva categoría si no existe
        if (!categorias.contains(_categoria)) {
          categorias.add(_categoria);
          await prefs.setStringList('categorias_personalizadas', categorias);

          // Crear una lista vacía para las notas de esta categoría
          await prefs.setString('notas_${_categoria}', json.encode([]));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoría creada exitosamente')),
          );
          Navigator.pop(context, true); // Retornar true para indicar éxito
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Esta categoría ya existe')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la categoría: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nueva categoría',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre para la categoría';
                  }
                  return null;
                },
                onChanged: (value) => _categoria = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCategoria,
                child: const Text('Crear categoría'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
