import 'package:flutter/material.dart';
import 'package:pencil/widgets/agenda_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;

class AgendaIconExample extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? recordatorioExistente;

  const AgendaIconExample({
    super.key,
    required this.selectedDate,
    this.recordatorioExistente,
  });

  @override
  State<AgendaIconExample> createState() => _AgendaIconExampleState();
}

class _AgendaIconExampleState extends State<AgendaIconExample> {
  final _formKey = GlobalKey<FormState>();
  // Se elimina la referencia a NotificationService debido a que no está definida
  TextEditingController _reminderController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  TextEditingController _minutoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recordatorioExistente != null) {
      _reminderController.text = widget.recordatorioExistente!['recordatorio'];
      _horaController.text = widget.recordatorioExistente!['hora']['hora'].toString();
      _minutoController.text = widget.recordatorioExistente!['hora']['minuto'].toString();
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _guardarRecordatorio() async {
    if (_formKey.currentState!.validate()) {
      // Crear DateTime para la notificación
      final fechaHora = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        int.parse(_horaController.text),
        int.parse(_minutoController.text),
      );

      // Generar ID único para la notificación
      final notificationId = fechaHora.millisecondsSinceEpoch ~/ 1000;

      final recordatorio = {
        'fecha': {
          'dia': widget.selectedDate.day,
          'mes': widget.selectedDate.month,
          'año': widget.selectedDate.year
        },
        'hora': {
          'hora': int.parse(_horaController.text),
          'minuto': int.parse(_minutoController.text)
        },
        'recordatorio': _reminderController.text,
        'notificationId': notificationId,
      };

      // Guardar el recordatorio
      final prefs = await SharedPreferences.getInstance();
      final String key = 'recordatorio_${widget.selectedDate.toIso8601String()}';
      await prefs.setString(key, json.encode(recordatorio));
      // Programar la notificación
      // Se elimina la referencia a _notificationService debido a que no está definida
      // Se asume que la programación de la notificación se realizará de manera diferente

      if (widget.recordatorioExistente != null) {
        // Cancelar notificación anterior si estamos editando
        if (widget.recordatorioExistente!.containsKey('notificationId')) {
          // Se elimina la referencia a _notificationService debido a que no está definida
          // Se asume que la cancelación de la notificación se realizará de manera diferente
        }
        Navigator.pop(context, 'updated');
      } else {
        Navigator.pop(context, recordatorio);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recordatorioExistente != null 
            ? 'Editar Recordatorio' 
            : 'Nuevo Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Fecha seleccionada:'),
                  subtitle: Text(_formatDate(widget.selectedDate)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _reminderController,
                decoration: InputDecoration(
                  labelText: 'Recordatorio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un recordatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _horaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hora (0-23)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        int? hora = int.tryParse(value);
                        if (hora == null || hora < 0 || hora > 23) {
                          return 'Hora inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _minutoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Minutos (0-59)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        int? minuto = int.tryParse(value);
                        if (minuto == null || minuto < 0 || minuto > 59) {
                          return 'Minutos inválidos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarRecordatorio,
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reminderController.dispose();
    _horaController.dispose();
    _minutoController.dispose();
    super.dispose();
  }
}

class DiaSeleccionado extends StatelessWidget {
  final DateTime fechaSeleccionada;

  const DiaSeleccionado({
    super.key,
    required this.fechaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Día Seleccionado'),
      ),
      body: Center(
        child: Text('Fecha seleccionada: ${fechaSeleccionada.toString()}'),
      ),
    );
  }
}