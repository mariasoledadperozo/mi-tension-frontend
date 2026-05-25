// lib/widgets/organismo_popup_analisis.dart

import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';

class OrganismoPopupAnalisis extends StatelessWidget {
  final PresionRegistroDto registro;

  const OrganismoPopupAnalisis({super.key, required this.registro});

  static String _imagenPorEstado(EstadoPresion estado) {
    switch (estado) {
      case EstadoPresion.normal:
        return 'assets/images/pressureAnalysis/low_pressure.jpg';
      case EstadoPresion.bien:
        return 'assets/images/pressureAnalysis/medium_pressure.jpg';
      case EstadoPresion.alta:
        return 'assets/images/pressureAnalysis/high_pressure.jpg';
      case EstadoPresion.muyAlta:
        return 'assets/images/pressureAnalysis/high_pressure.jpg';
    }
  }

  static String _tituloPorEstado(EstadoPresion estado) {
    switch (estado) {
      case EstadoPresion.normal:
        return 'Presión normal';
      case EstadoPresion.bien:
        return 'Presión ligeramente elevada';
      case EstadoPresion.alta:
        return 'Presión alta';
      case EstadoPresion.muyAlta:
        return 'Presión muy alta';
    }
  }

  static Future<void> mostrar(
    BuildContext context,
    PresionRegistroDto registro,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.whiteTextBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => OrganismoPopupAnalisis(registro: registro),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(_imagenPorEstado(registro.estado), height: 160),
            const SizedBox(height: 24),
            Text(
              _tituloPorEstado(registro.estado),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'sf',
                color: AppTheme.mainTitleBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              registro.mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.descriptionGray,
                fontFamily: 'sf',
              ),
            ),
            const SizedBox(height: 32),
            AtomoBotonPrincipal(
              label: "Entendido",
              color: AppTheme.primaryBlue,
              action: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
