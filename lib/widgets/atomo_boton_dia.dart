import 'package:flutter/material.dart';
import 'package:mi_tension/core/enums/diasSemana.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoBotonDia extends StatelessWidget {
  const AtomoBotonDia({
    super.key,
    required List<DiasSemana> diasSeleccionados,
    required this.entry,
  }) : _diasSeleccionados = diasSeleccionados;

  final List<DiasSemana> _diasSeleccionados;
  final MapEntry<DiasSemana, String> entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _diasSeleccionados.contains(entry.key)
            ? AppTheme.buttonGreen
            : AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        entry.value,
        style: TextStyle(
          color: _diasSeleccionados.contains(entry.key)
              ? AppTheme.whiteTextBackground
              : AppTheme.descriptionGray,
          fontWeight: FontWeight.bold,
          fontFamily: 'sf',
        ),
      ),
    );
  }
}
