import 'package:flutter/material.dart';

class SelectedDay extends StatelessWidget {
  final DateTime selectedDay;

  const SelectedDay({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Day'),
      ),
      body: Center(
        child: Text('Selected date: ${selectedDay.toString()}'),
      ),
    );
  }
} 