import 'dart:io';

class Documento {
    void imprimirValor(String valor) {
        print("La categora nueva es:  $valor");
    }

    Future<void> guardarCategoria(String valor) async {
        final archivo = File('categorias.txt');
        await archivo.writeAsString('$valor\n', mode: FileMode.append);
    }

    void imprimirCategorias() {
        final archivo = File('categorias.txt');
        if (archivo.existsSync()) {
            String contenido = archivo.readAsStringSync();
            print(contenido);
        } else {
            print("El archivo categorias.txt no existe.");
        }
    }
}
