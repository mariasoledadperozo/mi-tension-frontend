import 'package:flutter/material.dart';
import 'package:mi_tension/features/screens/login_screen.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_salir.dart';
import 'package:mi_tension/widgets/atomo_logo_principalTexto.dart';
import 'package:mi_tension/widgets/atomo_texto_descripcion.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const AtomoLogoPrincipalTexto(),
                      const SizedBox(width: 140),
                      AtomoBotonSalir(
                        action: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/onboarding/onboardingPic.jpg',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AtomoTextoDescripcion(
                    titulo: "Cuida tu presión día a día",
                    descripcion:
                        "Lleva un control sencillo de tus mediciones, registra tus valores fácilmente y recibe recordatorios de tu medicación para mantener tu salud bajo control cada día.",
                  ),
                  const SizedBox(height: 24),
                  AtomoBotonPrincipal(
                    label: "Comenzar",
                    color: AppTheme.primaryBlue,
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
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
