import 'package:coffeeya_admin/core/config/color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isSuccessful;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isSuccessful = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isSuccessful ? Colors.white : Colors.white,
        backgroundColor: isSuccessful ? XColors.green_8 : Colors.grey[900],
        surfaceTintColor: isSuccessful ? XColors.green_8 : Colors.grey[900],
        shadowColor: Colors.grey[900],
        disabledBackgroundColor: isSuccessful ? XColors.green_2 : Colors.grey[300],
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
