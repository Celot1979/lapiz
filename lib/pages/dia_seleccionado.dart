import 'package:flutter/material.dart';
import 'package:pencil/widgets/agenda_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AgendaIconExample extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? recordatorioExistente;

  const AgendaIconExample({
    Key? key, 
    required this.selectedDate, 
    this.recordatorioExistente,
  }) : super(key: key);

  @override
  State<AgendaIconExample> createState() => _AgendaIconExampleState();
}

class _AgendaIconExampleState extends State<AgendaIconExample> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _reminderController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  TextEditingController _minutoController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final recordatorio = {
                        'fecha': {
                          'dia': widget.selectedDate.day,
                          'mes': widget.selectedDate.month,
                          'año': widget.selectedDate.year
                        },
                        'hora': {
                          'hora': _selectedTime.hour,
                          'minuto': _selectedTime.minute
                        },
                        'recordatorio': _reminderController.text
                      };

                      // Guardar el recordatorio
                      final prefs = await SharedPreferences.getInstance();
                      final String key = 'recordatorio_${widget.selectedDate.toIso8601String()}';
                      await prefs.setString(key, json.encode(recordatorio));

                      // Volver a la página anterior con el resultado
                      Navigator.pop(context, recordatorio);
                    }
                  },
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