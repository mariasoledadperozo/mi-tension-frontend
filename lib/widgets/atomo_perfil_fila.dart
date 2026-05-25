import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoPerfilFila extends StatelessWidget {
  final String label;
  final String valor;
  final bool editable;
  final bool isImportant;
  final VoidCallback? onEdit;

  const AtomoPerfilFila({
    super.key,
    required this.label,
    required this.valor,
    this.editable = true,
    this.isImportant = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = isImportant ? AppTheme.buttonRed : AppTheme.mainTitleBlack;
    final labelColor = isImportant
        ? AppTheme.buttonRed
        : AppTheme.descriptionGray;

    return GestureDetector(
      onTap: !editable ? onEdit : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: isImportant
                  ? AppTheme.backgroundRed
                  : AppTheme.backgroundGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: color,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          valor,
                          style: TextStyle(fontSize: 16, color: labelColor),
                        ),
                      ],
                    ),
                  ),
                  if (editable)
                    IconButton(
                      icon: Icon(Icons.edit, color: labelColor, size: 18),
                      onPressed: onEdit,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
