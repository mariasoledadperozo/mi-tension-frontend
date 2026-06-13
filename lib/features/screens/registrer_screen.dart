import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/usuario_dto.dart';
import 'package:mi_tension/features/auth/services/auth_service.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/widgets/atomo_datepicker_principal.dart';
import 'package:mi_tension/widgets/atomo_dropdown_principal.dart';
import 'package:mi_tension/widgets/atomo_input_principal.dart';
import 'package:mi_tension/features/screens/verify_code_screen.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _password = TextEditingController();
  DateTime? _birthDate;
  String? _sex;
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _email = TextEditingController();
  final _confirmEmail = TextEditingController();
  var _meds = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _confirmEmail.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validateEmail() {
    String email = _email.text;

    if (!email.contains("@") || !email.contains(".")) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('El correo no tiene un formato válido'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    if (_name.text.isEmpty ||
        _surname.text.isEmpty ||
        _email.text.isEmpty ||
        _confirmEmail.text.isEmpty ||
        _password.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor rellena todos los campos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    if (email != _confirmEmail.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Los correos no coinciden'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _register() async {
    if (!_validateEmail()) return;
    try {
      await _authService.register({
        "nombre": _name.text,
        "apellidos": _surname.text,
        "email": _email.text,
        "password": _password.text,
        "fechaNacimiento": _birthDate != null
            ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}"
            : null,
        "sexo": UsuarioDto.sexToInt(_sex),
        "tomaMedicacion": _meds,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCodeScreen(email: _email.text),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
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
        titulo: "Crear cuenta",
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AtomoInputPrincipal(
                          label: "Nombre",
                          placeholder: "Ej: Sergio",
                          controller: _name,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AtomoInputPrincipal(
                          label: "Apellidos",
                          placeholder: "Ej: Lopez",
                          controller: _surname,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AtomoDatePickerPrincipal(
                    label: "Fecha Nacimiento",
                    onDateSelected: (fecha) => _birthDate = fecha,
                  ),
                  const SizedBox(height: 20),
                  AtomoDropdownPrincipal(
                    label: "Sexo",
                    options: ["Femenino", "Masculino", "Prefiero no decirlo"],
                    onChanged: (valor) => _sex = valor,
                    hint: "Ej: Masculino",
                  ),
                  const SizedBox(height: 20),
                  AtomoInputPrincipal(
                    label: "Correo electronico",
                    placeholder: "Ej: Mail@mail.com",
                    controller: _email,
                  ),
                  const SizedBox(height: 20),
                  AtomoInputPrincipal(
                    label: "Confirmar correo electronico",
                    placeholder: "Ej: Mail@mail.com",
                    controller: _confirmEmail,
                  ),
                  const SizedBox(height: 20),
                  AtomoInputPrincipal(
                    label: "Contraseña",
                    placeholder: "******",
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "¿Tomas medicina para la hipertensión?",
                        style: TextStyle(color: AppTheme.descriptionGray),
                      ),
                      Switch(
                        inactiveThumbColor: AppTheme.whiteTextBackground,
                        inactiveTrackColor: AppTheme.descriptionGray,
                        value: _meds,
                        onChanged: (valor) => setState(() => _meds = valor),
                        activeThumbColor: AppTheme.whiteTextBackground,
                        activeTrackColor: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AtomoBotonPrincipal(
                    label: "Crear",
                    color: AppTheme.primaryBlue,
                    action: () => _register(),
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
