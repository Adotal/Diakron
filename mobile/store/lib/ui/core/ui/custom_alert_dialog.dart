import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    this.actionButtonColor, // Renombrado para reflejar que ahora pinta el fondo del botón
    required this.onPressed,
    this.icon,
    this.children,
  });

  final String title;
  final String content;
  final String actionText;
  final Color? actionButtonColor;
  final VoidCallback onPressed;
  final IconData? icon;
  final List<Widget>? children;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String actionText,
    required VoidCallback onPressed,
    Color? actionButtonColor,
    IconData? icon,
    List<Widget>? children,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          actionText: actionText,
          onPressed: onPressed,
          actionButtonColor: actionButtonColor,
          icon: icon,
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si no se pasa un color (ej. para guardar/aceptar), usamos el verde
    // Si se pasa un color (ej. Colors.red para eliminar), usa ese.
    final primaryColor = actionButtonColor ?? const Color(0xFF38761D);

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: icon != null ? Icon(icon, size: 48, color: primaryColor) : null,
      title: Text(
        title,
        textAlign: icon != null ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            children ??
            [
              Text(
                content,
                textAlign: icon != null ? TextAlign.center : TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
      ),
      actionsPadding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
      actions: [
        // Botón Cancelar
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        // Botón de Acción Principal
        ElevatedButton(
          onPressed: () {
            onPressed();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                primaryColor, // Aquí aplicamos el Rojo, Verde, etc.
            foregroundColor: Colors.white, // El texto se mantiene blanco
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            actionText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
