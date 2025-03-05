import 'package:flutter/material.dart';
import 'package:pencil/pages/dia_seleccionado.dart';
import 'package:pencil/pages/selected_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import necesario para soporte de idiomas

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
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgendaIconExample(selectedDate: selectedDay),
            ),
          ).then((_) {
            setState(() {
              // Agregar el día seleccionado al conjunto de días con recordatorios
              _daysWithReminders.add(DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
              ));
            });
          });
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