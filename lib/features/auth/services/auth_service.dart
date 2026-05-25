import '../../../core/network/ApiClient.dart';
import '../../../core/storage/TokenStorage.dart';

///
/// Es el service que maneja todo lo que tenga que ver con tokens
/// es decir, sesiones.

class AuthService {
  final ApiClient apiClient = ApiClient(); //Para acceder a las peticiones

  // LOGIN
  Future<dynamic> login(String email, String password) async {
    final response = await apiClient.post("/Auth/login", {
      "email": email,
      "password": password,
    }); //Hago una response, mediante el endpoint con el email y la clave

    final token = response["token"]; //De la respuesta, cojo el token
    final userId = response["usuario"]["id"];
    await TokenStorage.saveToken(token); //Guardo el token de la respuesta
    await TokenStorage.saveUserId(userId);
    return response; //La respuesta del servidor en JSON
  }

  // REGISTRAR
  Future<dynamic> register(Map<String, dynamic> data) async {
    return await apiClient.post(
      "/Auth/register",
      data,
    ); // Usando las funciones de apiClient, le doy el endpoint y los datos
    // del usuario a registrar. ApiClient los convierte a JSON y los manda al servidor.
    //Devuelve un mensaje de error/exito
  }

  // Verificar codigo
  Future<dynamic> verifyCode(String email, String code) async {
    return await apiClient.post("/Auth/verificar-codigo", {
      //Lo mismo, a traves del endpoint, verifico el codigo
      "email": email,
      "codigo": code,
    });
  }

  // Reenviar confirmacion
  Future<dynamic> resendConfirmation(String email) async {
    return await apiClient.post(
      "/Auth/resend-confirmation",
      email,
    ); //Lo mismo, a traves del endpoint, verifico
  }
}
