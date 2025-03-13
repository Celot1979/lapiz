import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentosCategoria extends StatelessWidget {
  final String nombreCategoria;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentosCategoria({
    super.key,
    required this.nombreCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos - $nombreCategoria'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('categorias')
            .doc(nombreCategoria)
            .collection('documentos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay documentos en esta categoría'));
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
                  subtitle: Text(data['contenido'] ?? ''),
                  trailing: Text(data['fecha']?.toString() ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}