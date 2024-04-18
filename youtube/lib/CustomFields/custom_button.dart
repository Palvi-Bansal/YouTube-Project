import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final String? buttonText;
  final bool loading;

  const CustomButton({Key? key,
    this.onPressed,
    this.buttonText,
    this.loading = false,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
        ),
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: onPressed,
          child: Center(
            child: loading ? const CircularProgressIndicator(
              strokeWidth: 3, color: Colors.white,) : Text(
              buttonText!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
