import 'package:flutter/material.dart';
import 'package:login/features/widgets/form_wydnex.dart';
import 'package:login/features/widgets/input_wydnex.dart';

class PasswordInput extends StatefulWidget {
  final FormWydnex<String> value;
  final void Function(FormWydnex<String> value) onChanged;
  final String label;
  const PasswordInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return InputWydnex(
      value: widget.value,
      keyboardType: TextInputType.name,
      obscureText: obscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            // Cambia el estado de _obscureText al contrario
            obscureText = !obscureText;
          });
        },
        child: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      onChanged: (value) {
        widget.onChanged(value);
      },
      label: widget.label,
    );
  }
}
