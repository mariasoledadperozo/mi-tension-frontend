import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/estadisticas_dto.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/molecula_card_estadistica.dart';

class OrganismoCardResumen extends StatelessWidget {
  EstadisticasDto estadisticas;
  OrganismoCardResumen({super.key, required this.estadisticas});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Resumen últimos 30 días",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MoleculaCardEstadistica(
                label: "Sistólica",
                valor: "${estadisticas.promedioSistolica} mmHg",
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MoleculaCardEstadistica(
                label: "Diastólica",
                valor: "${estadisticas.promedioDiastolica} mmHg",
                color: AppTheme.buttonRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MoleculaCardEstadistica(
                label: "Pulso",
                valor: "${estadisticas.promedioPulso} bpm",
                color: AppTheme.buttonOrange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MoleculaCardEstadistica(
                label: "Total registros",
                valor: "${estadisticas.totalRegistros}",
                color: AppTheme.buttonGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
