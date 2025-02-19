import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pencil/pages/add_nota.dart';
import 'package:pencil/pages/edit_nota.dart';
//import 'package:pencil/pages/add_nota.dart';
import '../services/firebase_servicie.dart';

class Notas extends StatefulWidget {
  const Notas({super.key});

  @override
  State<Notas> createState() => _NotasState();
}

class _NotasState extends State<Notas> {
  final FirebaseService _firebaseService = FirebaseService();
  List _notas = [];

  void onButtonPressed(String tipo) async {
    List notas;
    if (tipo == "Personales") {
      notas = await _firebaseService.getNota("personal");
    } else if (tipo == "Profesionales") {
      notas = await _firebaseService.getNota("profesionales");
    } else {
      notas = await _firebaseService.getNota(tipo);
    }
    setState(() {
      _notas = notas;
    });
  }

  void _confirmDeleteNota(String collectionName, String notaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Borrado'),
          content: const Text('¿Estás seguro de que deseas borrar esta nota?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _firebaseService.deleteNota(collectionName, notaId);
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Navegar a la página de notas
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Notas()),
                );
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () => onButtonPressed("Personales"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Personales'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () => onButtonPressed("Profesionales"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Profesionales'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        // Acción para el botón "crear tema"
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('+'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.note),
                      title: Text(
                        _notas[index]['titulo'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_notas[index]['campo'] ?? ''),
                      tileColor: Colors.grey[200],
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDeleteNota(_notas[index]['clasificacion'], _notas[index]['id']),
                      ),
                      onTap: () {
                        // Navegar a la pantalla de edición pasando el ID y los datos de la nota
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNota(
                              notaId: _notas[index]['id'],
                              notaData: {
                                'titulo': _notas[index]['titulo'],
                                'campo': _notas[index]['campo'],
                                'clasificacion': _notas[index]['clasificacion'],
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.add, size: 30, color: Colors.black),
          //Icon(Icons.edit, size: 30, color: Colors.black),
          //Icon(Icons.delete, size: 30, color: Colors.black),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNota()),
            );
          // Aquí puedes añadir la lógica para manejar la navegación
        }
        }
      ),
    );
  }
}
