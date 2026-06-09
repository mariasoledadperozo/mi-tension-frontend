import 'dart:ui';
import 'package:mi_tension/core/enums/estadoPresion.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class PresionRegistroDto {
  final int id;
  final int sistolica;
  final int diastolica;
  final int? pulso;
  final String? notas;
  final DateTime fecha;
  final EstadoPresion estado;
  final String descripcion;
  final String mensaje;

  PresionRegistroDto({
    required this.id,
    required this.sistolica,
    required this.diastolica,
    this.pulso,
    this.notas,
    required this.fecha,
    required this.estado,
    required this.descripcion,
    required this.mensaje,
  });

  factory PresionRegistroDto.fromJson(Map<String, dynamic> json) {
    final clasificacion = json["clasificacion"];
    return PresionRegistroDto(
      id: (json["id"] ?? 0).toInt(),
      sistolica: (json["sistolica"] ?? 0).toInt(),
      diastolica: (json["diastolica"] ?? 0).toInt(),
      pulso: json["pulso"] != null ? (json["pulso"]).toInt() : null,
      notas: json["notas"],
      fecha: DateTime.parse(json["fecha"]),
      estado: clasificacion != null
          ? _mapearEstadoInt(clasificacion["categoria"] ?? 0)
          : EstadoPresion.normal,
      descripcion: clasificacion?["descripcion"] ?? "Sin clasificar",
      mensaje: clasificacion?["mensaje"] ?? "",
    );
  }

  static EstadoPresion _mapearEstadoInt(dynamic categoria) {
    if (categoria is String) {
      switch (categoria) {
        case 'Normal':
          return EstadoPresion.normal;
        case 'Bien':
          return EstadoPresion.bien;
        case 'Alta':
          return EstadoPresion.alta;
        case 'MuyAlta':
          return EstadoPresion.muyAlta;
        default:
          return EstadoPresion.normal;
      }
    }

    switch (categoria as int) {
      case 0:
        return EstadoPresion.normal;
      case 1:
        return EstadoPresion.bien;
      case 2:
        return EstadoPresion.alta;
      case 3:
        return EstadoPresion.muyAlta;
      default:
        return EstadoPresion.normal;
    }
  }

  Map<String, Color> get colorByEstado {
    switch (estado) {
      case EstadoPresion.normal:
        return {
          'font': AppTheme.buttonGreen,
          'background': AppTheme.backgroundGreen,
        };
      case EstadoPresion.bien:
        return {
          'font': AppTheme.buttonOrange,
          'background': AppTheme.backgroundOrange,
        };
      case EstadoPresion.alta:
        return {
          'font': AppTheme.buttonRed,
          'background': AppTheme.backgroundRed,
        };
      case EstadoPresion.muyAlta:
        return {
          'font': AppTheme.buttonRed,
          'background': AppTheme.backgroundRed,
        };
    }
  }
}
