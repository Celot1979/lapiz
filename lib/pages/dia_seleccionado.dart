import 'package:flutter/material.dart';
import 'package:pencil/widgets/agenda_icon.dart';

class AgendaIconExample extends StatefulWidget {
  final DateTime selectedDate;

  const AgendaIconExample({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<AgendaIconExample> createState() => _AgendaIconExampleState();
}

class _AgendaIconExampleState extends State<AgendaIconExample> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _reminderController = TextEditingController();

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Recordatorio'),
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
              ListTile(
                title: Text('Hora: ${_selectedTime.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
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
                      
                      print('Datos del recordatorio: $recordatorio');
                      
                      Navigator.pop(context);
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