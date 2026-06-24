import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text("$label: ${time?.format(context) ?? '--:--'}"),
      trailing: const Icon(Icons.access_time, size: 20),
      onTap: onTap,
    );
  }
}
