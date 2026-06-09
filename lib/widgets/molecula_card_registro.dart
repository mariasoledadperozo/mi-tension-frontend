import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_label_estadoPresion.dart';

class MoleculaCardRegistro extends StatelessWidget {
  final PresionRegistroDto registro;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;

  const MoleculaCardRegistro({
    super.key,
    required this.registro,
    this.onEditar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.descriptionGray.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${registro.sistolica}/${registro.diastolica}',
                        style: const TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.mainTitleBlack,
                          fontFamily: 'sf',
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'mmHg',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.descriptionGray,
                          fontFamily: 'sf',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.descriptionGray,
                ),
                onSelected: (value) {
                  if (value == 'editar') onEditar?.call();
                  if (value == 'eliminar') onEliminar?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppTheme.buttonRed),
                        SizedBox(width: 8),
                        Text(
                          'Eliminar',
                          style: TextStyle(color: AppTheme.buttonRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: AppTheme.descriptionGray, thickness: 1),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd-MM-yyyy, HH:mm').format(registro.fecha.toLocal()),
            style: const TextStyle(
              color: AppTheme.descriptionGray,
              fontFamily: 'sf',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          AtomoLabelEstadopresion(registro: registro),
        ],
      ),
    );
  }
}
