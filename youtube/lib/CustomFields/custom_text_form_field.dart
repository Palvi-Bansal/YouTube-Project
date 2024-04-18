import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onTogglePassword;


  const CustomTextFormField({super.key,
    required this.label,
    required this.keyboardType,
    required this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height:5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            showCursor: true,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: label == 'Password'? InkWell(
                  onTap: onTogglePassword,
                  child: Icon(
                    obscureText? Icons.visibility: Icons.visibility_off,
                  )) :null,
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}