import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeerCategoriaNota extends StatefulWidget {
  const LeerCategoriaNota({super.key});

  @override
  State<LeerCategoriaNota> createState() => _LeerCategoriaNotaState();
}

class _LeerCategoriaNotaState extends State<LeerCategoriaNota> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> categorias = [];

  @override
  void initState() {
    super.initState();
    _leerCategorias();
  }

  Future<void> _leerCategorias() async {
    try {
      print('\n=== Leyendo categorías de la base de datos "pencil" ===');

      // Obtener la colección de categorías
      QuerySnapshot categoriasSnapshot = await _firestore.collection('categorias').get();

      // Imprimir el número total de categorías encontradas
      print('Total de categorías encontradas: ${categoriasSnapshot.docs.length}');
      
      // Imprimir detalles de cada categoría
      print('\nListado de categorías:');
      for (var doc in categoriasSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('- ID: ${doc.id}');
        print('  Datos: ${data.toString()}');
        
        // Guardar las categorías en la lista para mostrarlas en la UI
        categorias.add(doc.id);
      }

      print('\n=== Fin de la lectura de categorías ===');

      // Actualizar el estado para mostrar las categorías en la UI
      setState(() {});

    } catch (e) {
      print('Error al leer categorías: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías Existentes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Categorías encontradas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(categorias[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
