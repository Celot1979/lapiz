import 'package:flutter/material.dart';



class Notas extends StatefulWidget {
  const Notas({super.key});

  @override
  State<Notas> createState() => _NotasState();
}

class _NotasState extends State<Notas> {
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
                      onPressed: () {
                        // Acción para el botón "personales"
                      },
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
                      onPressed: () {
                        // Acción para el botón "profesionales"
                      },
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
            // Eliminar el logo
            // Image.asset(
            //   'img/logo.jpg',
            //   width: 400,
            //   height: 600,
            // ),
            // const SizedBox(height: 20),
            // Eliminar el botón de logearte
            // FilledButton(
            //   onPressed: () async {
            //     
            //   },
            //   style: FilledButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   ),
            //   child: SizedBox(
            //     width: 150,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.login),
            //         SizedBox(width: 8),
            //         Text(
            //           'Logeate',
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}