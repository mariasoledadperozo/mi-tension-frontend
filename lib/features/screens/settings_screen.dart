import 'package:flutter/material.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/auth/models/usuario_dto.dart';
import 'package:mi_tension/features/auth/services/usuario_service.dart';
import 'package:mi_tension/features/screens/onboarding_screen.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_perfil_fila.dart';
import 'package:mi_tension/widgets/atomo_texto_subTitulo.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:mi_tension/widgets/organismo_card_sinInformacion.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  bool _cargando = true;
  bool _error = false;
  UsuarioDto? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      final usuarioApi = await _usuarioService.obtenerUsuario();
      if (!mounted) return;
      setState(() {
        _usuario = usuarioApi;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = true;
        _cargando = false;
      });
    }
  }

  void _editarCampo(
    String label,
    String valorActual,
    Function(String) onGuardar,
  ) {
    final controller = TextEditingController(text: valorActual);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $label"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await onGuardar(controller.text);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _editarSexo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Sexo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Masculino"),
              onTap: () async {
                Navigator.pop(context);
                await _guardarCambio(
                  UsuarioDto(
                    nombre: _usuario!.nombre,
                    apellidos: _usuario!.apellidos,
                    email: _usuario!.email,
                    fechaNacimiento: _usuario!.fechaNacimiento,
                    sexo: 0,
                    tomaMedicina: _usuario!.tomaMedicina,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Femenino"),
              onTap: () async {
                Navigator.pop(context);
                await _guardarCambio(
                  UsuarioDto(
                    nombre: _usuario!.nombre,
                    apellidos: _usuario!.apellidos,
                    email: _usuario!.email,
                    fechaNacimiento: _usuario!.fechaNacimiento,
                    sexo: 1,
                    tomaMedicina: _usuario!.tomaMedicina,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Otro"),
              onTap: () async {
                Navigator.pop(context);
                await _guardarCambio(
                  UsuarioDto(
                    nombre: _usuario!.nombre,
                    apellidos: _usuario!.apellidos,
                    email: _usuario!.email,
                    fechaNacimiento: _usuario!.fechaNacimiento,
                    sexo: 2,
                    tomaMedicina: _usuario!.tomaMedicina,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editarMedicacion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Toma medicación"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Sí"),
              onTap: () async {
                Navigator.pop(context);
                await _guardarCambio(
                  UsuarioDto(
                    nombre: _usuario!.nombre,
                    apellidos: _usuario!.apellidos,
                    email: _usuario!.email,
                    fechaNacimiento: _usuario!.fechaNacimiento,
                    sexo: _usuario!.sexo,
                    tomaMedicina: true,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("No"),
              onTap: () async {
                Navigator.pop(context);
                await _guardarCambio(
                  UsuarioDto(
                    nombre: _usuario!.nombre,
                    apellidos: _usuario!.apellidos,
                    email: _usuario!.email,
                    fechaNacimiento: _usuario!.fechaNacimiento,
                    sexo: _usuario!.sexo,
                    tomaMedicina: false,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarCambio(UsuarioDto usuarioActualizado) async {
    try {
      final usuarioApi = await _usuarioService.editarUsuario(
        usuarioActualizado,
      );
      if (!mounted) return;
      setState(() => _usuario = usuarioApi);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cambios guardados")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar los cambios")),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    await TokenStorage.clearAll();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sesión cerrada correctamente")),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false,
    );
  }

  Future<void> _cerrarCuenta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar cuenta"),
        content: const Text(
          "¿Estás seguro? Esta acción es irreversible y eliminará todos tus datos.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.buttonRed),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar cuenta"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final userId = await TokenStorage.getUserId();
      await _usuarioService.eliminarUsuario(userId!);
      await TokenStorage.clearAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta eliminada correctamente")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar la cuenta")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(titulo: "Configuracion"),
      body: _cargando
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(),
              ),
            )
          : _error || _usuario == null
          ? const Center(
              child: OrganismoCardSininformacion(
                descripcion: "Comprueba tu conexión e inténtalo de nuevo",
              ),
            )
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Row(
                          children: [AtomoTextoSubtitulo(label: "Perfil")],
                        ),
                        const SizedBox(height: 5),
                        AtomoPerfilFila(
                          label: "Nombre",
                          valor: _usuario!.nombre,
                          onEdit: () => _editarCampo(
                            "Nombre",
                            _usuario!.nombre,
                            (v) => _guardarCambio(
                              UsuarioDto(
                                nombre: v,
                                apellidos: _usuario!.apellidos,
                                email: _usuario!.email,
                                fechaNacimiento: _usuario!.fechaNacimiento,
                                sexo: _usuario!.sexo,
                                tomaMedicina: _usuario!.tomaMedicina,
                              ),
                            ),
                          ),
                        ),
                        AtomoPerfilFila(
                          label: "Apellidos",
                          valor: _usuario!.apellidos,
                          onEdit: () => _editarCampo(
                            "Apellidos",
                            _usuario!.apellidos,
                            (v) => _guardarCambio(
                              UsuarioDto(
                                nombre: _usuario!.nombre,
                                apellidos: v,
                                email: _usuario!.email,
                                fechaNacimiento: _usuario!.fechaNacimiento,
                                sexo: _usuario!.sexo,
                                tomaMedicina: _usuario!.tomaMedicina,
                              ),
                            ),
                          ),
                        ),
                        AtomoPerfilFila(
                          label: "Sexo",
                          valor: _usuario!.sexoTexto,
                          onEdit: _editarSexo,
                        ),
                        AtomoPerfilFila(
                          label: "Fecha Nacimiento",
                          valor:
                              "${_usuario!.fechaNacimiento.day}/${_usuario!.fechaNacimiento.month}/${_usuario!.fechaNacimiento.year}",
                          onEdit: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate: _usuario!.fechaNacimiento,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (fecha != null) {
                              await _guardarCambio(
                                UsuarioDto(
                                  nombre: _usuario!.nombre,
                                  apellidos: _usuario!.apellidos,
                                  email: _usuario!.email,
                                  fechaNacimiento: fecha,
                                  sexo: _usuario!.sexo,
                                  tomaMedicina: _usuario!.tomaMedicina,
                                ),
                              );
                            }
                          },
                        ),
                        AtomoPerfilFila(
                          label: "Correo",
                          valor: _usuario!.email,
                          onEdit: () => _editarCampo(
                            "Correo",
                            _usuario!.email,
                            (v) => _guardarCambio(
                              UsuarioDto(
                                nombre: _usuario!.nombre,
                                apellidos: _usuario!.apellidos,
                                email: v,
                                fechaNacimiento: _usuario!.fechaNacimiento,
                                sexo: _usuario!.sexo,
                                tomaMedicina: _usuario!.tomaMedicina,
                              ),
                            ),
                          ),
                        ),
                        AtomoPerfilFila(
                          label: "Toma medicacion",
                          valor: _usuario!.tomaMedicina ? "Sí" : "No",
                          onEdit: _editarMedicacion,
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [AtomoTextoSubtitulo(label: "Cuenta")],
                        ),
                        const SizedBox(height: 5),
                        AtomoPerfilFila(
                          label: "Cerrar sesion",
                          valor: "Cierra la sesion en este dispositivo",
                          onEdit: _cerrarSesion,
                          editable: false,
                        ),
                        AtomoPerfilFila(
                          label: "Cerrar cuenta",
                          valor: "Eliminar la cuenta",
                          isImportant: true,
                          onEdit: _cerrarCuenta,
                          editable: false,
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
