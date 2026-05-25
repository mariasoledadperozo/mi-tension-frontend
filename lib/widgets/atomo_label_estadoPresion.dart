import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';

class AtomoLabelEstadopresion extends StatelessWidget {
  final PresionRegistroDto registro;
  const AtomoLabelEstadopresion({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    final colorBackground = registro.colorByEstado['background'];
    final colorFont = registro.colorByEstado['font'];

    final texto = registro.descripcion.toLowerCase() == "sin clasificacion"
        ? "No se ha podido clasificar"
        : "Tu presión es ${registro.descripcion}";

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 16,
            color: colorFont,
            fontFamily: 'sf',
            fontWeight: FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
