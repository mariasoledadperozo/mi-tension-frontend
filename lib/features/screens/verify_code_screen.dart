import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/services/auth_service.dart';
import 'package:mi_tension/features/screens/login_screen.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/widgets/atomo_texto_descripcion.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState(); // ✅
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  // ✅
  final _authService = AuthService();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verificar() async {
    try {
      await _authService.verifyCode(widget.email, _codeController.text);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('¡Cuenta creada!'),
          content: const Text('Tu cuenta ha sido verificada correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(), // ✅
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Código incorrecto, inténtalo de nuevo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(
        titulo: "Verifica tu cuenta",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/verificarCodigo/AtomoIconoCelular.png",
                    width: double.infinity,
                  ),
                  AtomoTextoDescripcion(
                    titulo: "Verifica tu codigo",
                    descripcion:
                        "Introduce el código que hemos enviado a tu correo para activar tu cuenta.",
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: _codeController,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.descriptionGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mainTitleBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AtomoBotonPrincipal(
                    label: "Verificar",
                    color: AppTheme.primaryBlue,
                    action: () => _verificar(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
