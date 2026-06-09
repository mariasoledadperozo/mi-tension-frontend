import 'package:mi_tension/core/enums/diasSemana.dart';

class RecordatorioDto {
  final String id;
  final String nombreMedicina;
  final String dosis;
  final String hora;
  final List<DiasSemana> dias;
  final bool activo;

  RecordatorioDto({
    required this.id,
    required this.nombreMedicina,
    required this.dosis,
    required this.hora,
    required this.dias,
    required this.activo,
  });

  factory RecordatorioDto.fromJson(Map<String, dynamic> json) {
    return RecordatorioDto(
      id: json['id'].toString(),
      nombreMedicina: json['nombreMedicina'],
      dosis: json['dosis'],
      hora: json['hora'],
      dias: (json['dias'] as List)
          .map((d) => DiasSemana.values[d as int])
          .toList(),
      activo: json['activo'] ?? true,
    );
  }
}
