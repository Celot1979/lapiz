import 'package:flutter/material.dart';
import 'package:pencil/services/firebase_servicie.dart';

class EditNota extends StatefulWidget {
  final String notaId; // ID de la nota seleccionada
  final Map<String, dynamic> notaData; // Datos de la nota

  EditNota({required this.notaId, required this.notaData});

  @override
  _EditNotaState createState() => _EditNotaState();
}

class _EditNotaState extends State<EditNota> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.notaData['titulo']);
    _contenidoController = TextEditingController(text: widget.notaData['campo']);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contenidoController,
                decoration: InputDecoration(labelText: 'Contenido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese contenido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Imprimir en la terminal los valores
                    print('Título: ${_tituloController.text}');
                    print('Contenido: ${_contenidoController.text}');
                    print('Clasificación: ${widget.notaData['clasificacion']}');

                    Map<String, dynamic> updatedNota = {
                      'titulo': _tituloController.text,
                      'campo': _contenidoController.text,
                      'clasificacion': widget.notaData['clasificacion'],
                    };
                    
                    await FirebaseService().updateNota(widget.notaId, updatedNota);
                    // Redirigir a la página notas.dart
                    Navigator.pushReplacementNamed(context, '/notas');
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
