import 'package:flutter/material.dart';

class DaySchedule {
  final String dayName;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  bool isOpen;

  DaySchedule({
    required this.dayName,
    this.openTime,
    this.closeTime,
    this.isOpen = false,
  });

  // Helper to convert TimeOfDay to "HH:mm" string
  String? timeToString(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}