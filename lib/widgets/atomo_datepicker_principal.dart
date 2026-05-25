import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoDatePickerPrincipal extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime>? onDateSelected;
  final String hint;

  const AtomoDatePickerPrincipal({
    super.key,
    required this.label,
    this.onDateSelected,
    this.hint = "Seleccionar fecha",
  });

  @override
  State<AtomoDatePickerPrincipal> createState() =>
      _AtomoDatePickerPrincipalState();
}

class _AtomoDatePickerPrincipalState extends State<AtomoDatePickerPrincipal> {
  DateTime? _fecha;

  Future<void> _abrirCalendario() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (seleccionada != null) {
      setState(() => _fecha = seleccionada);
      widget.onDateSelected?.call(seleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texto = _fecha == null
        ? widget.hint
        : '${_fecha!.day.toString().padLeft(2, '0')}/${_fecha!.month.toString().padLeft(2, '0')}/${_fecha!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppTheme.descriptionGray,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _abrirCalendario,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.descriptionGray),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    texto,
                    style: TextStyle(
                      fontSize: 16,
                      color: _fecha != null
                          ? AppTheme.mainTitleBlack
                          : AppTheme.descriptionGray,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppTheme.descriptionGray,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
