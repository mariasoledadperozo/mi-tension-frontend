import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoTextoDescripcion extends StatelessWidget {
  final String titulo;
  final String? descripcion;
  final bool start;

  const AtomoTextoDescripcion({
    super.key,
    required this.titulo,
    this.descripcion,
    this.start = false,
  });

  @override
  Widget build(BuildContext context) {
    final alineacion = start ? TextAlign.start : TextAlign.center;

    return Column(
      children: [
        Text(
          titulo,
          textAlign: alineacion,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            fontFamily: 'sf',
            color: AppTheme.mainTitleBlack,
          ),
        ),
        if (descripcion != null) ...[
          const SizedBox(height: 8),
          Text(
            descripcion!,
            textAlign: alineacion,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'sf',
              color: AppTheme.descriptionGray,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
