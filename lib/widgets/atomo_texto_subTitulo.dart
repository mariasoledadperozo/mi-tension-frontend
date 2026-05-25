import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoTextoSubtitulo extends StatelessWidget {
  final String label;
  const AtomoTextoSubtitulo({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      textAlign: TextAlign.start,
      style: TextStyle(color: AppTheme.descriptionGray),
    );
  }
}
