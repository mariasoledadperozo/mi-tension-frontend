import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoBotonSalir extends StatelessWidget {
  final VoidCallback action;

  const AtomoBotonSalir({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.whiteTextBackground,
        elevation: 0,
        overlayColor: AppTheme.transparent,
      ),
      child: const Icon(Icons.close, color: AppTheme.descriptionGray),
    );
  }
}
