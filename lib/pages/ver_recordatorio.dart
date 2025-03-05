import 'package:flutter/material.dart';
import 'package:pencil/pages/dia_seleccionado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VerRecordatorio extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, dynamic> recordatorio;

  const VerRecordatorio({
    super.key, 
    required this.selectedDate,
    required this.recordatorio,
  });

  String formatearHora(Map<String, dynamic> recordatorio) {
    String hora = recordatorio['hora']['hora'].toString().padLeft(2, '0');
    String minuto = recordatorio['hora']['minuto'].toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorio'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaIconExample(
                    selectedDate: selectedDate,
                    recordatorioExistente: recordatorio,
                  ),
                ),
              );

              if (result != null) {
                // Actualizar la vista con el recordatorio editado
                Navigator.pop(context, 'updated');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Mostrar diálogo de confirmación
              bool? confirmar = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Eliminar Recordatorio'),
                    content: Text('¿Estás seguro de que deseas eliminar este recordatorio?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('Eliminar'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              if (confirmar == true) {
                final prefs = await SharedPreferences.getInstance();
                final key = 'recordatorio_${selectedDate.toIso8601String()}';
                await prefs.remove(key);
                Navigator.pop(context, 'deleted');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Fecha:'),
                subtitle: Text('${recordatorio['fecha']['dia']}/'
                    '${recordatorio['fecha']['mes']}/'
                    '${recordatorio['fecha']['año']}'),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Hora programada:'),
                subtitle: Text(formatearHora(recordatorio)),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.note),
                title: Text('Recordatorio:'),
                subtitle: Text(recordatorio['recordatorio']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}