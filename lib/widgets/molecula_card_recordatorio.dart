import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/recordatorio_dto.dart';
import 'package:mi_tension/features/auth/services/reminders_service.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/atomo_boton_dia.dart';

class MoleculaCardRecordatorio extends StatefulWidget {
  final RecordatorioDto recordatorio;

  const MoleculaCardRecordatorio({super.key, required this.recordatorio});

  @override
  State<MoleculaCardRecordatorio> createState() =>
      _MoleculaCardRecordatorioState();
}

class _MoleculaCardRecordatorioState extends State<MoleculaCardRecordatorio> {
  final _service = RemindersService();

  late bool _activo;
  late bool _eliminado;
  late TextEditingController _nombreController;
  late TextEditingController _dosisController;
  late TextEditingController _horaController;
  late List<DiasSemana> _diasSeleccionados;

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
  void initState() {
    super.initState();
    _activo = widget.recordatorio.activo;
    _eliminado = false;
    _nombreController = TextEditingController(
      text: widget.recordatorio.nombreMedicina,
    );
    _dosisController = TextEditingController(text: widget.recordatorio.dosis);
    _horaController = TextEditingController(
      text: widget.recordatorio.hora.length >= 5
          ? widget.recordatorio.hora.substring(0, 5)
          : widget.recordatorio.hora,
    );
    _diasSeleccionados = List.from(widget.recordatorio.dias);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _dosisController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  void _abrirMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                title: const Text('Editar', style: TextStyle(fontFamily: 'sf')),
                onTap: () {
                  Navigator.pop(context);
                  _abrirEdicion();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppTheme.buttonRed),
                title: const Text(
                  'Eliminar',
                  style: TextStyle(fontFamily: 'sf', color: AppTheme.buttonRed),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmarEliminar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _abrirEdicion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar recordatorio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sf',
                      color: AppTheme.mainTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del medicamento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dosisController,
                    decoration: const InputDecoration(
                      labelText: 'Dosis',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _horaController,
                    decoration: const InputDecoration(
                      labelText: 'Hora (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Días',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sf',
                      color: AppTheme.mainTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final entry in _etiquetasDias.entries)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
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
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: AppTheme.whiteTextBackground,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await _service.editarRecordatorio(
                            int.parse(widget.recordatorio.id),
                            {
                              "nombreMedicina": _nombreController.text,
                              "dosis": _dosisController.text,
                              "hora": _horaController.text,
                              "dias": _diasSeleccionados
                                  .map((d) => d.name)
                                  .toList(),
                              "activo": _activo,
                            },
                          );
                          setState(() {
                            _diasSeleccionados = List.from(_diasSeleccionados);
                          });
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al guardar los cambios'),
                              ),
                            );
                          }
                        }
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        'Guardar',
                        style: TextStyle(fontFamily: 'sf', fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmarEliminar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Eliminar recordatorio',
            style: TextStyle(fontFamily: 'sf'),
          ),
          content: Text(
            '¿Seguro que quieres eliminar "${widget.recordatorio.nombreMedicina}"?',
            style: const TextStyle(fontFamily: 'sf'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(fontFamily: 'sf')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _service.eliminarRecordatorio(
                    int.parse(widget.recordatorio.id),
                  );
                  setState(() => _eliminado = true);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al eliminar el recordatorio'),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(fontFamily: 'sf', color: AppTheme.buttonRed),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_eliminado) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.descriptionGray.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _nombreController.text,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mainTitleBlack,
                  fontFamily: 'sf',
                ),
              ),
              Switch(
                value: _activo,
                activeColor: AppTheme.primaryBlue,
                onChanged: (value) async {
                  setState(() => _activo = value);
                  try {
                    await _service.toggleRecordatorio(
                      int.parse(widget.recordatorio.id),
                    );
                  } catch (e) {
                    if (mounted) {
                      setState(() => _activo = !value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al cambiar el estado'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          Text(
            _horaController.text,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.descriptionGray,
              fontFamily: 'sf',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    for (final entry in _etiquetasDias.entries)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _diasSeleccionados.contains(entry.key)
                                ? AppTheme.buttonGreen
                                : AppTheme.backgroundGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 12,
                              color: _diasSeleccionados.contains(entry.key)
                                  ? AppTheme.whiteTextBackground
                                  : AppTheme.descriptionGray,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'sf',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.descriptionGray,
                ),
                onPressed: _abrirMenu,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
