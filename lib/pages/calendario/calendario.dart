import 'package:flutter/material.dart';
import 'package:pencil/pages/calendario/dia_seleccionado.dart';
import 'package:pencil/pages/calendario/selected_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import necesario para soporte de idiomas
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pencil/pages/calendario/ver_recordatorio.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _daysWithReminders = {}; // Nuevo conjunto para días con recordatorios

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES'); // Inicializar formato en español
    _loadMarkedDays(); // Cargar días guardados
  }

  // Función para cargar los días marcados
  Future<void> _loadMarkedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final String? markedDaysJson = prefs.getString('marked_days');
    
    if (markedDaysJson != null) {
      final List<dynamic> decodedList = json.decode(markedDaysJson);
      setState(() {
        _daysWithReminders = decodedList
            .map((dateString) => DateTime.parse(dateString))
            .toSet();
      });
    }
  }

  // Función para guardar los días marcados
  Future<void> _saveMarkedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dateStrings = _daysWithReminders
        .map((date) => date.toIso8601String())
        .toList();
    await prefs.setString('marked_days', json.encode(dateStrings));
  }

  Future<Map<String, dynamic>?> getRecordatorio(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'recordatorio_${date.toIso8601String()}';
    final String? recordatorioJson = prefs.getString(key);
    
    if (recordatorioJson != null) {
      return json.decode(recordatorioJson);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today), // Ícono de agenda
            onPressed: () {
              // Acción al presionar el ícono
              print('Ícono de agenda presionado');
            },
          ),
        ],
      ),
      body: TableCalendar(
        locale: 'es_ES', // Configurar en español
        firstDay: DateTime.utc(1979, 3, 6),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) async {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          bool hasReminder = _daysWithReminders.contains(DateTime(
            selectedDay.year,
            selectedDay.month,
            selectedDay.day,
          ));

          if (hasReminder) {
            final recordatorio = await getRecordatorio(selectedDay);
            if (recordatorio != null) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerRecordatorio(
                    selectedDate: selectedDay,
                    recordatorio: recordatorio,
                  ),
                ),
              );

              // Manejar el resultado de ver/editar el recordatorio
              if (result == 'deleted') {
                setState(() {
                  _daysWithReminders.remove(DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  ));
                  _saveMarkedDays();
                });
              } else if (result == 'updated') {
                // Recargar los datos del calendario si es necesario
                await _loadMarkedDays();
              }
            }
          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgendaIconExample(selectedDate: selectedDay),
              ),
            );

            if (result != null) {
              setState(() {
                _daysWithReminders.add(DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                ));
                _saveMarkedDays();
              });
            }
          }
        },
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
          weekendStyle: TextStyle(color: Colors.red),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.red),
          // Agregar decoración para días con recordatorios
          markerDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            // Verificar si el día tiene un recordatorio
            bool hasReminder = _daysWithReminders.contains(DateTime(
              day.year,
              day.month,
              day.day,
            ));
            
            if (hasReminder) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}