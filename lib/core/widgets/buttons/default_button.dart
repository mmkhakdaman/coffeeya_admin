import 'package:flutter/material.dart';

import '../../config/color.dart';

class DefaultButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isDanger;

  const DefaultButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isDanger ? XColors.red_7 : XColors.gray_4,
        surfaceTintColor: isDanger ? XColors.red_5 : XColors.gray_5,
        foregroundColor: isDanger ? XColors.white : XColors.gray_9,
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
