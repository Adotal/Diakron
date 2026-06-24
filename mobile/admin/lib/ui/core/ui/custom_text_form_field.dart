import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.keyboardType,
    this.minMaxLines,
    this.maxLength,
    this.enabled = true,
    this.isPassword = false,
  });

  final bool isPassword;
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;
  final int? minMaxLines;
  final int? maxLength;
  final bool enabled;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    // Un radio ligeramente más amplio da un aspecto más moderno y amigable
    final borderRadius = BorderRadius.circular(16);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Un poco más de aire entre campos
      child: TextFormField(
        enabled: widget.enabled,
        minLines: widget.minMaxLines,
        maxLines: widget.isPassword ? 1 : widget.minMaxLines,
        maxLength: widget.maxLength,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _passwordObscured : false,

        style: TextStyle(
          color: widget.enabled ? AppColors.black1 : Colors.black54,
          fontSize: 16,
          fontWeight: widget.enabled ? FontWeight.w500 : FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          // Añadimos padding interno para que el texto respire
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          suffixIcon: !widget.isPassword
              ? null
              : IconButton(
                  icon: Icon(
                    _passwordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: widget.enabled
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordObscured = !_passwordObscured;
                    });
                  },
                ),

          // Estilo del label flotante (cuando el campo está enfocado/lleno)
          floatingLabelStyle: TextStyle(
            color: widget.enabled
                ? AppColors.greenDiakron1
                : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),

          // Estilo del label en reposo
          labelStyle: TextStyle(
            color: widget.enabled ? Colors.grey.shade500 : Colors.grey.shade400,
            fontSize: 15,
          ),

          // Fondos: Blanco si está activo, gris sutil si está deshabilitado
          filled: true,
          fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,

          // --- ESTADOS DE LOS BORDES ---
          border: OutlineInputBorder(borderRadius: borderRadius),

          // Reposo
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            borderRadius: borderRadius,
          ),

          // Enfocado (escribiendo)
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greenDiakron1, width: 2),
            borderRadius: borderRadius,
          ),

          // Error
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            borderRadius: borderRadius,
          ),

          // Error y enfocado
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            borderRadius: borderRadius,
          ),

          // Deshabilitado (línea muy tenue en lugar de desaparecer por completo)
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            borderRadius: borderRadius,
          ),
        ),
        cursorColor: AppColors
            .greenDiakron1, // El cursor hace match con tu color principal
      ),
    );
  }
}