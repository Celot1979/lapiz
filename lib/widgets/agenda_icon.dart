import 'package:flutter/material.dart';

class AgendaIcon extends StatelessWidget {
  final DateTime selectedDate;

  const AgendaIcon({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getMonthAbbreviation(selectedDate.month),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '${selectedDate.day}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'ENE';
      case 2: return 'FEB';
      case 3: return 'MAR';
      case 4: return 'ABR';
      case 5: return 'MAY';
      case 6: return 'JUN';
      case 7: return 'JUL';
      case 8: return 'AGO';
      case 9: return 'SEP';
      case 10: return 'OCT';
      case 11: return 'NOV';
      case 12: return 'DIC';
      default: return '';
    }
  }
} 