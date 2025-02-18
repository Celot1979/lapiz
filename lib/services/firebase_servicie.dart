import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getNota(String tipo) async {
    List notas = [];
    try {
      String coleccion;
      // Filtrar según el tipo
      if(tipo == "personal") {
        coleccion = 'personal';
      } else {
        coleccion = 'profesionales';
      }
      
      var collectionRef = _firestore.collection(coleccion);
      var snapshot = await collectionRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        // Mostrar mensaje emergente si la colección no existe
        print('La colección $coleccion no existe.'); // Aquí puedes reemplazar con un método para mostrar un mensaje emergente
        return [];
      }
      
      QuerySnapshot querySnapshot = await collectionRef
          .get(); // Eliminado el filtrado por 'clasificacion' para obtener todas las notas de la colección
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        notas.add({
          'id': doc.id,
          'clasificacion': data['clasificacion'],
          'titulo': data['titulo'],
          'campo': data['campo'],
        });
      }
      return notas;
    } catch (e) {
      print('Error al obtener notas: $e');
      return [];
    }
  }

  Future<void> addNota(Map<String, dynamic> nota) async {
    try {
      String coleccion = nota['clasificacion']; // Obtener el nombre de la colección del campo 'clasificacion'
      
      // Verificar si la colección existe
      var collectionRef = _firestore.collection(coleccion);
      var snapshot = await collectionRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        print('La colección $coleccion no existe. Creando nueva colección.');
      }
      
      // Añadir la nota a la colección
      await collectionRef.add(nota); // Añadir la nota a la colección
      print('Nota añadida a la colección $coleccion');
    } catch (e) {
      print('Error al añadir nota: $e');
    }
  }


  Future<void> updateNota(String id, Map<String, dynamic> nuevaNota) async {
    try {
      // Referencia a la colección de la nota
      String coleccion = nuevaNota['clasificacion'];
      var collectionRef = _firestore.collection(coleccion);
      
      // Asegurarse de que 'nuevaNota' contenga todos los campos necesarios
      if (nuevaNota.isNotEmpty) {
        // Actualizar la nota en la colección
        await collectionRef.doc(id).update(nuevaNota);
        print('Nota con id $id actualizada en la colección $coleccion');
      } else {
        print('No se proporcionaron datos para actualizar la nota.');
      }
    } catch (e) {
      print('Error al actualizar nota: $e');
    }
  }
}