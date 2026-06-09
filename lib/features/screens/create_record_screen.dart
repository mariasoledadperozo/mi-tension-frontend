import 'package:flutter/material.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:mi_tension/features/auth/services/pressure_records_service.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/widgets/atomo_input_principal.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:mi_tension/widgets/organismo_popup_analisis.dart';

class CreateRecordScreen extends StatefulWidget {
  const CreateRecordScreen({super.key});

  @override
  State<CreateRecordScreen> createState() => _CreateRecordScreenState();
}

class _CreateRecordScreenState extends State<CreateRecordScreen> {
  final _service = PressureRecordsService();

  final _sistolicaController = TextEditingController();
  final _diastolicaController = TextEditingController();
  final _pulsoController = TextEditingController();
  final _notaController = TextEditingController();

  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  bool _guardando = false;

  @override
  void dispose() {
    _sistolicaController.dispose();
    _diastolicaController.dispose();
    _pulsoController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (fecha != null) setState(() => _fechaSeleccionada = fecha);
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) setState(() => _horaSeleccionada = hora);
  }

  String _formatearFecha() {
    if (_fechaSeleccionada == null) return 'DD/MM/AAAA';
    return '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}/'
        '${_fechaSeleccionada!.month.toString().padLeft(2, '0')}/'
        '${_fechaSeleccionada!.year}';
  }

  String _formatearHora() {
    if (_horaSeleccionada == null) return '--:--';
    return '${_horaSeleccionada!.hour.toString().padLeft(2, '0')}:'
        '${_horaSeleccionada!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _guardar() async {
    if (_sistolicaController.text.isEmpty ||
        _diastolicaController.text.isEmpty ||
        _fechaSeleccionada == null ||
        _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rellena todos los campos obligatorios")),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final userId = await TokenStorage.getUserId();

      final fecha = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );

      final response = await _service.crearRegistro({
        'usuarioId': userId,
        'sistolica': int.parse(_sistolicaController.text),
        'diastolica': int.parse(_diastolicaController.text),
        'pulso': _pulsoController.text.isEmpty
            ? 0
            : int.parse(_pulsoController.text),
        'fecha': fecha.toIso8601String(),
        'notas': _notaController.text,
      });

      if (!mounted) return;

      final registro = PresionRegistroDto.fromJson({
        ...Map<String, dynamic>.from(response['registro']),
        'clasificacion': response['analisis'],
      });

      await OrganismoPopupAnalisis.mostrar(context, registro);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e, stack) {
      debugPrint('ERROR: $e');
      debugPrint('STACK: $stack');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(
        titulo: "Registrar medición",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AtomoInputPrincipal(
                          label: "Sistólica",
                          placeholder: "Ej: 90",
                          controller: _sistolicaController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AtomoInputPrincipal(
                          label: "Diastólica",
                          placeholder: "Ej: 120",
                          controller: _diastolicaController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AtomoInputPrincipal(
                    label: "Pulso (opcional)",
                    placeholder: "Ej: 72",
                    controller: _pulsoController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "HORA",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppTheme.descriptionGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _seleccionarHora,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.descriptionGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatearHora(),
                        style: TextStyle(
                          color: _horaSeleccionada == null
                              ? AppTheme.descriptionGray
                              : AppTheme.mainTitleBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "FECHA DEL REGISTRO",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppTheme.descriptionGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _seleccionarFecha,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.descriptionGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatearFecha(),
                        style: TextStyle(
                          color: _fechaSeleccionada == null
                              ? AppTheme.descriptionGray
                              : AppTheme.mainTitleBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "NOTA",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppTheme.descriptionGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notaController,
                    maxLines: 4,
                    style: const TextStyle(color: AppTheme.mainTitleBlack),
                    decoration: InputDecoration(
                      hintText: "Ej: Fue después de tomar una siesta",
                      hintStyle: const TextStyle(
                        color: AppTheme.descriptionGray,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.descriptionGray,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.descriptionGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _guardando
                      ? const Center(child: CircularProgressIndicator())
                      : AtomoBotonPrincipal(
                          label: "Guardar",
                          color: AppTheme.primaryBlue,
                          action: _guardar,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
