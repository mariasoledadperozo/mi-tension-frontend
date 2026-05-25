enum DiasSemana { lunes, martes, miercoles, jueves, viernes, sabado, domingo }

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
          .map(
            (d) => DiasSemana.values.firstWhere(
              (e) => e.name.toLowerCase() == d.toString().toLowerCase(),
            ),
          )
          .toList(),
      activo: json['activo'] ?? true,
    );
  }
}
