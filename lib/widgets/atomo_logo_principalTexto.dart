import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoLogoPrincipalTexto extends StatelessWidget {
  const AtomoLogoPrincipalTexto({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 45,
          height: 45,
          child: Image.asset('assets/images/AtomoLogoPrincipal.png'),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.primaryBlue, // azul
              fontFamily: 'sf',
            ),
            children: [
              TextSpan(
                text: 'Mi',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: 'Tension',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
