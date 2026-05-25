import '../../../core/network/ApiClient.dart';

class PressureRecordsService {
  final ApiClient _apiClient = ApiClient();

  // Obtener todos los registros del usuario
  Future<dynamic> getRegistrosByUsuario(String usuarioId) async {
    return await _apiClient.get("/RegistrosPresion/usuario/$usuarioId");
  }

  // Obtener historial con análisis
  Future<dynamic> getHistorialConAnalisis(String usuarioId) async {
    return await _apiClient.get(
      "/RegistrosPresion/usuario/$usuarioId/historial-con-analisis",
    );
  }

  // Crear un nuevo registro
  Future<dynamic> crearRegistro(Map<String, dynamic> data) async {
    return await _apiClient.post("/RegistrosPresion", data);
  }

  // Eliminar registro
  Future<dynamic> eliminarRegistro(String id) async {
    return await _apiClient.delete("/RegistrosPresion/$id", null);
  }

  // Obtener estadísticas del usuario  ← el que faltaba
  Future<dynamic> getEstadisticasByUsuario(
    String usuarioId, {
    int dias = 30,
  }) async {
    return await _apiClient.get(
      "/RegistrosPresion/usuario/$usuarioId/estadisticas?dias=$dias",
    );
  }
}
