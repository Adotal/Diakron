import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerTile extends StatelessWidget {
  final String label;
  final String? path;
  final VoidCallback onPick;

  const ImagePickerTile({
    super.key,
    required this.label,
    this.path,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    bool hasFile = path != null && path!.isNotEmpty;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias, // Para que la imagen respete el redondeo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: hasFile ? Colors.green : Colors.grey.shade300),
      ),
      color: hasFile ? Colors.green.shade50 : Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onPick,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // Miniatura de la imagen o ícono por defecto
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: hasFile
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(path!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                  ),
                )
              : const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          hasFile ? "Toca para cambiar imagen" : "Seleccionar Logo (PNG, JPG)",
          style: TextStyle(
            fontSize: 12,

            color: hasFile ? Colors.green.shade700 : Colors.grey,
          ),
        ),
        // Botón de visualización a pantalla completa
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () => _showFullImage(context),
              )
            : const Icon(Icons.add_photo_alternate_outlined),
      ),
    );
  }

  // Dialog rápido para ver la imagen en grande
  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(path!)),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      ),
    );
  }
}
