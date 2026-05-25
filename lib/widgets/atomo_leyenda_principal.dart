import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoLeyendaPrincipal extends StatefulWidget {
  Color color;
  String label;
  AtomoLeyendaPrincipal({super.key, required this.label, required this.color});

  @override
  State<AtomoLeyendaPrincipal> createState() => _AtomoLeyendaPrincipalState();
}

class _AtomoLeyendaPrincipalState extends State<AtomoLeyendaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          widget.label,
          style: const TextStyle(fontSize: 12, color: AppTheme.descriptionGray),
        ),
      ],
    );
  }
}
