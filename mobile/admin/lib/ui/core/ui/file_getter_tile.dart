import 'package:flutter/material.dart';

class FileGetterTile extends StatelessWidget {
  final String label;
  final VoidCallback onPick;

  const FileGetterTile({
    super.key,
    required this.label,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.picture_as_pdf,
          color: Colors.grey,
        ),
        title: Text(
          label, 
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: const Text(
          "Toca para visualizar PDF",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPick, 
      ),
    );
  }
}