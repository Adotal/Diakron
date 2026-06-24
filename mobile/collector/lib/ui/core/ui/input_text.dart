// Widget auxiliar para los campos de texto
// Usado en ingreso de email, contraseña, etc.

import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,  
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _passwordObscured : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          suffixIcon: !widget.isPassword
              ? null
              : IconButton(
                  icon: Icon(
                    _passwordObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordObscured = !_passwordObscured;
                    });
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
