import 'package:flutter/material.dart';
import 'package:mi_tension/core/enums/diasSemana.dart';
import 'package:mi_tension/features/auth/models/recordatorio_dto.dart';
import 'package:mi_tension/features/auth/services/reminders_service.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_dia.dart';
import 'package:mi_tension/widgets/atomo_boton_principal.dart';
import 'package:mi_tension/widgets/atomo_input_principal.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';

class CreateReminderScreen extends StatefulWidget {
  const CreateReminderScreen({super.key});

  @override
  State<CreateReminderScreen> createState() =>
      _AgregarRecordatorioScreenState();
}

class _AgregarRecordatorioScreenState extends State<CreateReminderScreen> {
  final _service = RemindersService();

  final _medicamentoController = TextEditingController();
  final _dosisController = TextEditingController();
  final _horaController = TextEditingController();

  final List<DiasSemana> _diasSeleccionados = [];
  bool _activo = true;
  bool _guardando = false;

  static const _etiquetasDias = {
    DiasSemana.lunes: 'L',
    DiasSemana.martes: 'M',
    DiasSemana.miercoles: 'M',
    DiasSemana.jueves: 'J',
    DiasSemana.viernes: 'V',
    DiasSemana.sabado: 'S',
    DiasSemana.domingo: 'D',
  };

  @override
  void dispose() {
    _medicamentoController.dispose();
    _dosisController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      final horaFormateada =
          '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}:00';
      setState(() => _horaController.text = horaFormateada);
    }
  }

  Future<void> _guardar() async {
    if (_medicamentoController.text.isEmpty ||
        _dosisController.text.isEmpty ||
        _horaController.text.isEmpty ||
        _diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rellena todos los campos")));
      return;
    }

    setState(() => _guardando = true);

    try {
      final userId = await TokenStorage.getUserId();
      await _service.crearRecordatorio({
        'usuarioId': userId,
        'nombreMedicina': _medicamentoController.text,
        'dosis': _dosisController.text,
        'hora': _horaController.text,
        'dias': _diasSeleccionados.map((d) => d.index).toList(), // <-- fix
        'activo': _activo,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recordatorio creado correctamente")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(
        titulo: "Crear recordatorio",
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
                  AtomoInputPrincipal(
                    label: "Medicamento",
                    placeholder: "Ej: Alprazolam",
                    controller: _medicamentoController,
                  ),
                  const SizedBox(height: 16),
                  AtomoInputPrincipal(
                    label: "Dosis",
                    placeholder: "Ej: 10mg",
                    controller: _dosisController,
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
                        _horaController.text.isEmpty
                            ? '--:--'
                            : _horaController.text,
                        style: TextStyle(
                          color: _horaController.text.isEmpty
                              ? AppTheme.descriptionGray
                              : AppTheme.mainTitleBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "DÍAS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppTheme.descriptionGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final entry in _etiquetasDias.entries)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_diasSeleccionados.contains(entry.key)) {
                                _diasSeleccionados.remove(entry.key);
                              } else {
                                _diasSeleccionados.add(entry.key);
                              }
                            });
                          },
                          child: AtomoBotonDia(
                            diasSeleccionados: _diasSeleccionados,
                            entry: entry,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ACTIVAR RECORDATORIO",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppTheme.descriptionGray,
                        ),
                      ),
                      Switch(
                        inactiveThumbColor: AppTheme.whiteTextBackground,
                        inactiveTrackColor: AppTheme.descriptionGray,
                        value: _activo,
                        onChanged: (valor) => setState(() => _activo = valor),
                        activeThumbColor: AppTheme.whiteTextBackground,
                        activeTrackColor: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _guardando
                      ? const Center(child: CircularProgressIndicator())
                      : AtomoBotonPrincipal(
                          label: "Crear",
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
