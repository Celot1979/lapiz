import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotasCategoriaPersonalizada extends StatefulWidget {
  final String nombreCategoria;

  const NotasCategoriaPersonalizada({
    super.key,
    required this.nombreCategoria,
  });

  @override
  State<NotasCategoriaPersonalizada> createState() => _NotasCategoriaPersonalizadaState();
}

class _NotasCategoriaPersonalizadaState extends State<NotasCategoriaPersonalizada> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas - ${widget.nombreCategoria}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('categorias')
            .doc(widget.nombreCategoria)
            .collection('notas')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay notas en esta categoría'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data['titulo'] ?? 'Sin título'),
                  subtitle: Text(data['contenido'] ?? 'Sin contenido'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarNota(doc.id, data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarNota(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _agregarNota(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _agregarNota() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _DialogoNota(),
    );

    if (result != null) {
      try {
        await _firestore
            .collection('categorias')
            .doc(widget.nombreCategoria)
            .collection('notas')
            .add({
          'titulo': result['titulo'],
          'contenido': result['contenido'],
          'fecha': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la nota: $e')),
        );
      }
    }
  }

  Future<void> _editarNota(String id, Map<String, dynamic> data) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _DialogoNota(
        tituloInicial: data['titulo'],
        contenidoInicial: data['contenido'],
      ),
    );

    if (result != null) {
      try {
        await _firestore
            .collection('categorias')
            .doc(widget.nombreCategoria)
            .collection('notas')
            .doc(id)
            .update({
          'titulo': result['titulo'],
          'contenido': result['contenido'],
          'fecha_modificacion': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la nota: $e')),
        );
      }
    }
  }

  Future<void> _eliminarNota(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _firestore
            .collection('categorias')
            .doc(widget.nombreCategoria)
            .collection('notas')
            .doc(id)
            .delete();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la nota: $e')),
        );
      }
    }
  }
}

class _DialogoNota extends StatefulWidget {
  final String? tituloInicial;
  final String? contenidoInicial;

  const _DialogoNota({
    this.tituloInicial,
    this.contenidoInicial,
  });

  @override
  State<_DialogoNota> createState() => _DialogoNotaState();
}

class _DialogoNotaState extends State<_DialogoNota> {
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tituloInicial);
    _contenidoController = TextEditingController(text: widget.contenidoInicial);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tituloInicial == null ? 'Nueva Nota' : 'Editar Nota'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contenidoController,
            decoration: const InputDecoration(
              labelText: 'Contenido',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'titulo': _tituloController.text,
              'contenido': _contenidoController.text,
            });
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
} 