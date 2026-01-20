import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final bool isExpanded;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.buttonTextColor),
              const SizedBox(width: 8),
              Text(label, style: AppTheme.buttonTextStyle(context)),
            ],
          )
        : Text(label, style: AppTheme.buttonTextStyle(context));

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.buttonBackgroundColor,
        foregroundColor: AppTheme.buttonTextColor,
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.paddingMedium,
          horizontal: AppTheme.paddingLarge,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: child,
    );

    return isExpanded ? Expanded(child: button) : button;
  }
}
