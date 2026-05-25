import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoDropdownPrincipal extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final String hint;

  const AtomoDropdownPrincipal({
    super.key,
    required this.label,
    required this.options,
    this.onChanged,
    required this.hint,
  });

  @override
  State<AtomoDropdownPrincipal> createState() => _AtomoDropdownPrincipalState();
}

class _AtomoDropdownPrincipalState extends State<AtomoDropdownPrincipal> {
  String? _seleccionado;

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<String>(
          initialValue: _seleccionado,
          hint: Text(
            widget.hint,
            style: TextStyle(color: AppTheme.descriptionGray),
          ),
          items: widget.options
              .map((op) => DropdownMenuItem(value: op, child: Text(op)))
              .toList(),
          onChanged: (val) {
            setState(() => _seleccionado = val);
            if (val != null) widget.onChanged?.call(val);
          },
          style: const TextStyle(color: AppTheme.mainTitleBlack, fontSize: 16),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.descriptionGray,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.descriptionGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.descriptionGray),
            ),
          ),
        ),
      ],
    );
  }
}
