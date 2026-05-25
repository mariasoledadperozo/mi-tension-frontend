class EstadisticasDto {
  final int totalRegistros;
  final int promedioSistolica;
  final int promedioDiastolica;
  final int promedioPulso;
  final int registrosNormales;
  final int registrosBien;
  final int registrosAltos;
  final int registrosMuyAltos;

  EstadisticasDto({
    required this.totalRegistros,
    required this.promedioSistolica,
    required this.promedioDiastolica,
    required this.promedioPulso,
    required this.registrosNormales,
    required this.registrosBien,
    required this.registrosAltos,
    required this.registrosMuyAltos,
  });

  factory EstadisticasDto.fromJson(Map<String, dynamic> json) {
    return EstadisticasDto(
      totalRegistros: json["totalRegistros"] ?? 0,
      promedioSistolica: json["promedioSistolica"] ?? 0,
      promedioDiastolica: json["promedioDiastolica"] ?? 0,
      promedioPulso: json["promedioPulso"] ?? 0,
      registrosNormales: json["registrosNormales"] ?? 0,
      registrosBien: json["registrosBien"] ?? 0,
      registrosAltos: json["registrosAltos"] ?? 0,
      registrosMuyAltos: json["registrosMuyAltos"] ?? 0,
    );
  }
}
