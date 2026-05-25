///
/// Es donde manejamos los tokens, haciendo acciones sobre el y haciendo
/// que permanezca la sesion abierta.
///
library;

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  ///
  /// En guardar, no devuelve nada.
  ///  En el abres
  static Future<void> saveToken(String token) async {
    final prefs =
        await SharedPreferences.getInstance(); //Obtengo el shared preferences, el cual es un archivo XML donde hay datos que se necesita recordar mientras esta instalada

    await prefs.setString("jwt_token", token); //Le doy una etiqueta y un valor
    //Etiqueta y contenido
  }

  // Obtener el token, puede estar vacio
  static Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance(); //Obtengo el shared preferences

    return prefs.getString(
      "jwt_token",
    ); //Y Lo cogemos segun su etiqueta y lo devuelvo
  }

  // Borrar, no devuele nada
  static Future<void> clearToken() async {
    final prefs =
        await SharedPreferences.getInstance(); //Obtengo el shared preferences

    await prefs.remove("jwt_token"); //Lo elimino segun su etiqueta
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("user_id");
  }
}
