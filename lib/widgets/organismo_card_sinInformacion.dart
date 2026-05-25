import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class OrganismoCardSininformacion extends StatelessWidget {
  final String descripcion;
  const OrganismoCardSininformacion({super.key, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 70),
        ClipRRect(child: Image.asset("assets/images/home/empty_state.jpg")),
        Text(
          descripcion,
          style: TextStyle(color: AppTheme.descriptionGray, fontSize: 16),
        ),
      ],
    );
  }
}
