import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/features/auth/models/recordatorio_dto.dart';
import 'package:mi_tension/features/auth/services/notification_service.dart';
import 'package:mi_tension/features/auth/services/reminders_service.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:mi_tension/widgets/molecula_card_recordatorio.dart';
import 'package:mi_tension/widgets/organismo_card_sinInformacion.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _service = RemindersService();
  List<RecordatorioDto> _recordatorios = [];
  bool _cargando = true;
  bool _errorConexion = false;

  @override
  void initState() {
    super.initState();
    _cargarRecordatorios();
  }

  Future<void> _cargarRecordatorios() async {
    if (!mounted) return;
    setState(() {
      _cargando = true;
      _errorConexion = false;
    });

    final userId = await TokenStorage.getUserId();
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorConexion = true;
      });
      return;
    }

    try {
      final response = await _service.getRecordatoriosByUsuario(userId);

      for (final recordatorio in response) {
        try {
          if (recordatorio.activo) {
            await NotificationService.programarRecordatorio(recordatorio);
          } else {
            await NotificationService.cancelarRecordatorio(recordatorio.id);
          }
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() {
        _recordatorios = response;
        _cargando = false;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorConexion = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorConexion = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(titulo: "Recordatorios"),
      body: _cargando
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(),
              ),
            )
          : _errorConexion
          ? const Center(
              child: OrganismoCardSininformacion(
                descripcion: "Comprueba tu conexión e inténtalo de nuevo",
              ),
            )
          : _recordatorios.isEmpty
          ? const Center(
              child: OrganismoCardSininformacion(
                descripcion:
                    'No tienes recordatorios. Añade uno para empezar tu seguimiento.',
              ),
            )
          : SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _recordatorios
                          .map(
                            (r) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: MoleculaCardRecordatorio(recordatorio: r),
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
