import 'dart:ui';
import 'package:mi_tension/features/theme/app_theme.dart';

enum EstadoPresion { normal, bien, alta, muyAlta }

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
      id: json["id"] ?? 0,
      sistolica: json["sistolica"],
      diastolica: json["diastolica"],
      pulso: json["pulso"],
      notas: json["notas"],
      fecha: DateTime.parse(json["fecha"]),
      estado: clasificacion != null
          ? _mapearEstado(clasificacion["categoria"] ?? "normal")
          : EstadoPresion.normal,
      descripcion: clasificacion?["descripcion"] ?? "Sin clasificar",
      mensaje: clasificacion?["mensaje"] ?? "",
    );
  }

  static EstadoPresion _mapearEstado(String categoria) {
    switch (categoria.toLowerCase().replaceAll(' ', '')) {
      case "normal":
        return EstadoPresion.normal;
      case "bien":
        return EstadoPresion.bien;
      case "alta":
        return EstadoPresion.alta;
      case "muyalta":
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
