import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_leyenda_principal.dart';

class OrganismoCardGraficos extends StatelessWidget {
  List<PresionRegistroDto> historial;
  OrganismoCardGraficos({super.key, required this.historial});

  @override
  Widget build(BuildContext context) {
    final registros = historial.take(10).toList().reversed.toList();

    final spots1 = registros.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.sistolica.toDouble());
    }).toList();

    final spots2 = registros.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.diastolica.toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Evolución de presión",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AtomoLeyendaPrincipal(
              label: "Sistólica",
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 16),
            AtomoLeyendaPrincipal(
              label: "Diastólica",
              color: AppTheme.buttonRed,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: AppTheme.backgroundGrey, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 20,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.descriptionGray,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= registros.length) {
                        return const SizedBox();
                      }
                      if (index != 0 &&
                          index != registros.length - 1 &&
                          index != registros.length ~/ 2) {
                        return const SizedBox();
                      }
                      return Text(
                        DateFormat('dd/MM').format(registros[index].fecha),
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.descriptionGray,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: 40,
              maxY: 200,
              lineBarsData: [
                LineChartBarData(
                  spots: spots1,
                  isCurved: true,
                  color: AppTheme.primaryBlue,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: spots2,
                  isCurved: true,
                  color: AppTheme.buttonRed,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
