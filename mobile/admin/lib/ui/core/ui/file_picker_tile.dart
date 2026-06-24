import 'package:flutter/material.dart';

class FilePickerTile extends StatelessWidget {
  final String label;
  final String? path;
  final VoidCallback onPick;

  const FilePickerTile({
    super.key,
    required this.label,
    this.path,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    bool hasFile = path != null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: hasFile ? Colors.green : Colors.grey.shade300),
      ),
      color: hasFile ? Colors.green.shade50 : Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.picture_as_pdf,
          color: hasFile ? Colors.green : Colors.grey,
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          hasFile
              ? "Presiona para cambiar archivo"
              : "Toca para seleccionar PDF",
          style: TextStyle(
            fontSize: 12,
            color: hasFile ? Colors.green.shade700 : Colors.grey,
          ),
        ),
        // BOTÓN PARA ABRIR EL DOCUMENTO
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () async {
                  // Lógica para abrir el archivo local
                  if (path != null) {
                    // await OpenFilex.open(path!);
                  }
                },
                tooltip: "Ver documento",
              )
            : const Icon(Icons.chevron_right),
        onTap:
            onPick, // El área general sigue sirviendo para cambiar el archivo
      ),
    );
  }
}
