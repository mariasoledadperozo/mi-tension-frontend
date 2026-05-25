import 'package:mi_tension/core/network/ApiClient.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/auth/models/estadisticas_dto.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';

class EstadisticasService {
  final ApiClient _api = ApiClient();

  Future<EstadisticasDto> getEstadisticas() async {
    final userId = await TokenStorage.getUserId();
    final data = await _api.get(
      "/RegistrosPresion/usuario/$userId/estadisticas",
    );
    return EstadisticasDto.fromJson(data);
  }

  Future<List<PresionRegistroDto>> getHistorialConAnalisis() async {
    final userId = await TokenStorage.getUserId();
    final data = await _api.get(
      "/RegistrosPresion/usuario/$userId/historial-con-analisis",
    );
    if (data is! List) return [];
    List<PresionRegistroDto> historial = [];
    for (var item in data) {
      final registro = Map<String, dynamic>.from(item["registro"]);
      final analisis = item["analisis"];
      if (analisis == null) continue;
      registro["clasificacion"] = analisis;
      historial.add(PresionRegistroDto.fromJson(registro));
    }
    return historial;
  }

  Future<void> eliminarRegistro(int id) async {
    await _api.delete("/RegistrosPresion/$id", null);
  }

  Future<PresionRegistroDto> actualizarRegistro(
    int id, {
    required int sistolica,
    required int diastolica,
    int? pulso,
    String? notas,
    DateTime? fecha,
  }) async {
    final body = {
      "sistolica": sistolica,
      "diastolica": diastolica,
      if (pulso != null) "pulso": pulso,
      if (notas != null) "notas": notas,
      if (fecha != null) "fecha": fecha.toUtc().toIso8601String(),
    };
    final data = await _api.put("/RegistrosPresion/$id", body);
    final registro = Map<String, dynamic>.from(data["registro"]);
    final analisis = data["analisis"];
    registro["clasificacion"] = analisis;
    return PresionRegistroDto.fromJson(registro);
  }
}
