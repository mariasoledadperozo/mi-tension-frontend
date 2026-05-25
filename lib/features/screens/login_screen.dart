import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/services/auth_service.dart';
import 'package:mi_tension/features/screens/registrer_screen.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/widgets/atomo_input_principal.dart';
import 'package:mi_tension/widgets/atomo_logo_principalTexto.dart';
import 'package:mi_tension/widgets/atomo_texto_descripcion.dart';
import 'package:mi_tension/widgets/organismo_homeMenu_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Rellena todos los campos'),
        ),
      );
      return;
    }

    try {
      await _authService.login(_email.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrganismoHomeMenuPrincipal(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const AtomoLogoPrincipalTexto(),
                  const SizedBox(height: 20),
                  const AtomoTextoDescripcion(
                    titulo: "Iniciar sesión",
                    start: true,
                  ),
                  const SizedBox(height: 20),
                  AtomoInputPrincipal(
                    label: "Correo",
                    placeholder: "Ej: tucorreo@mail.com",
                    controller: _email,
                  ),
                  const SizedBox(height: 10),
                  AtomoInputPrincipal(
                    label: "Contraseña",
                    placeholder: "****",
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(height: 20),
                  AtomoBotonPrincipal(
                    label: "Iniciar sesión",
                    color: AppTheme.primaryBlue,
                    action: _login,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.descriptionGray,
                          fontFamily: 'sf',
                        ),
                        children: [
                          const TextSpan(text: '¿No tienes cuenta?'),
                          TextSpan(
                            text: ' Crea una',
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
