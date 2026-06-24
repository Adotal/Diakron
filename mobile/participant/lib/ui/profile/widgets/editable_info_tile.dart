// WIDGET: EditableInfoTile
import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class EditableInfoTile extends StatefulWidget {
  const EditableInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.controller,
    this.onSave,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextEditingController? controller; // Si es null, no es editable
  final VoidCallback? onSave;

  @override
  State<EditableInfoTile> createState() => _EditableInfoTileState();
}

class _EditableInfoTileState extends State<EditableInfoTile> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final isEditable = widget.controller != null;

    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.greenDiakron1.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(widget.icon, color: AppColors.greenDiakron1),
          ),
          title: Text(
            widget.label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          // Si estamos editando mostramos el TextField, si no el texto normal
          subtitle: _isEditing
              ? TextField(
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF38761D)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF38761D),
                        width: 2,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  // Si no estamos editando, mostramos el texto del controlador (si existe)
                  // para reflejar cambios previos, o el valor inicial si está vacío
                  isEditable && widget.controller!.text.isNotEmpty
                      ? widget.controller!.text
                      : widget.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          // Lógica del botón trailing (Lápiz para editar, X para cancelar)
          trailing: isEditable
              ? (_isEditing
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                            // Precargamos el texto actual en el controlador
                            if (widget.controller!.text.isEmpty) {
                              widget.controller!.text = widget.value;
                            }
                          });
                        },
                      ))
              : null,
        ),

        // Botón de guardar animado que aparece cuando _isEditing es true
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _isEditing
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                        if (widget.onSave != null) {
                          widget.onSave!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38761D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Guardar cambios'),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
