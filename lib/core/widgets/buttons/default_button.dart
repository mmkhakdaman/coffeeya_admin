import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const DefaultButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[900],
        surfaceTintColor: Colors.grey[100],
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: child,
    );
  }
}
