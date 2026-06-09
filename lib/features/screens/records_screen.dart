import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:mi_tension/features/auth/services/estadisticas_service.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:mi_tension/widgets/molecula_card_registro.dart';
import 'package:mi_tension/widgets/organismo_card_sinInformacion.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final _service = EstadisticasService();
  List<PresionRegistroDto> _historial = [];
  bool _cargando = true;
  bool _errorConexion = false;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    if (!mounted) return;
    setState(() {
      _cargando = true;
      _errorConexion = false;
    });
    try {
      final historial = await _service.getHistorialConAnalisis();
      if (!mounted) return;
      setState(() {
        _historial = historial;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorConexion = true;
      });
    }
  }

  Future<void> _eliminar(PresionRegistroDto registro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Seguro que quieres eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.buttonRed),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await _service.eliminarRegistro(registro.id);
      await _cargarHistorial();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el registro')),
      );
    }
  }

  Future<void> _editar(PresionRegistroDto registro) async {
    final sistolicaCtrl = TextEditingController(
      text: registro.sistolica.toString(),
    );
    final diastolicaCtrl = TextEditingController(
      text: registro.diastolica.toString(),
    );
    final pulsoCtrl = TextEditingController(
      text: registro.pulso?.toString() ?? '',
    );
    final notasCtrl = TextEditingController(text: registro.notas ?? '');

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar registro'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sistolicaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sistólica'),
              ),
              TextField(
                controller: diastolicaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Diastólica'),
              ),
              TextField(
                controller: pulsoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pulso'),
              ),
              TextField(
                controller: notasCtrl,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;
    try {
      await _service.actualizarRegistro(
        registro.id,
        sistolica: int.parse(sistolicaCtrl.text),
        diastolica: int.parse(diastolicaCtrl.text),
        pulso: pulsoCtrl.text.isNotEmpty ? int.parse(pulsoCtrl.text) : null,
        notas: notasCtrl.text.isNotEmpty ? notasCtrl.text : null,
      );
      await _cargarHistorial();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(titulo: "Historial"),
      body: _cargando
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(),
              ),
            )
          : _errorConexion
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: OrganismoCardSininformacion(
                  descripcion: "Comprueba tu conexión e inténtalo de nuevo",
                ),
              ),
            )
          : _historial.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: OrganismoCardSininformacion(
                  descripcion:
                      "Empieza añadiendo información para realizar tu seguimiento",
                ),
              ),
            )
          : SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _historial
                          .map(
                            (r) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: MoleculaCardRegistro(
                                registro: r,
                                onEditar: () => _editar(r),
                                onEliminar: () => _eliminar(r),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
