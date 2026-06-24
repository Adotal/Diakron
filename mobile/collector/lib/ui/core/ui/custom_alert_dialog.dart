// custom_dialog.dart
import 'package:flutter/material.dart';

// Custom Dialog, offers two options, first is always 'cancel' and second is customizable
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    this.actionTextColor = Colors.blue,
    this.onPressed,
  });

  final String title;
  final String content;
  final String actionText;
  final Color? actionTextColor;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Exec and pop d
            if(onPressed != null) {
              onPressed!();
            }
            Navigator.pop(context);
          },
          child: Text(actionText, style: TextStyle(color: actionTextColor)),
        ),
      ],
    );
  }
}
