import 'package:flutter/material.dart';

class DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? dateTime;
  final VoidCallback? onTap;
  final bool enabled;
  const DatePickerTile({
    super.key,
    required this.label,
    this.dateTime,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Formateo manual simple: YYYY-MM-DD
    final dateString = dateTime != null
        ? "${dateTime!.day}-${dateTime!.month}-${dateTime!.year}"
        : '--/--/--';

    return ListTile(
      enabled: enabled,
      dense: true,
      // Cambiado 'time' por 'dateString' y el icono a calendario
      title: Text("$label: $dateString"),
      trailing: const Icon(Icons.calendar_today, size: 20),
      onTap: onTap,
    );
  }
}
