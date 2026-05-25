import '../../../core/network/ApiClient.dart';
import '../models/recordatorio_dto.dart';

class RemindersService {
  final ApiClient _api = ApiClient();

  Future<List<RecordatorioDto>> getRecordatoriosByUsuario(
    String usuarioId,
  ) async {
    final data = await _api.get("/Recordatorios/usuario/$usuarioId");
    if (data is List) {
      return data.map((e) => RecordatorioDto.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> crearRecordatorio(Map<String, dynamic> data) async {
    await _api.post("/Recordatorios", data);
  }

  Future<void> eliminarRecordatorio(int id) async {
    await _api.delete("/Recordatorios/$id", null);
  }

  Future<void> editarRecordatorio(int id, Map<String, dynamic> data) async {
    await _api.put("/Recordatorios/$id", data);
  }

  Future<void> toggleRecordatorio(int id) async {
    await _api.put("/Recordatorios/$id/toggle", {});
  }
}
