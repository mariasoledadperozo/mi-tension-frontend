import 'package:mi_tension/core/network/ApiClient.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/auth/models/usuario_dto.dart';

class UsuarioService {
  final ApiClient _api = ApiClient();

  Future<UsuarioDto> obtenerUsuario() async {
    final userId = await TokenStorage.getUserId();
    final data = await _api.get("/Usuarios/$userId");
    return UsuarioDto.fromJson(data);
  }

  Future<UsuarioDto> editarUsuario(UsuarioDto usuario) async {
    final userId = await TokenStorage.getUserId();
    await _api.put("/Usuarios/$userId", usuario.toJson());
    return usuario;
  }

  Future<void> eliminarUsuario(String userId) async {
    await _api.delete("/Usuarios/$userId", null);
  }
}
