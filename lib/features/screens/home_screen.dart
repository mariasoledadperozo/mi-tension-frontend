import 'dart:convert';
import 'package:mi_tension/features/auth/models/presion_registro_dto.dart';
import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/models/estadisticas_dto.dart';
import 'package:mi_tension/features/auth/services/estadisticas_service.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'package:mi_tension/widgets/atomo_texto_descripcion.dart';
import 'package:mi_tension/widgets/molecula_appBar_principal.dart';
import 'package:mi_tension/widgets/molecula_card_registro.dart';
import 'package:mi_tension/widgets/organismo_card_graficos.dart';
import 'package:mi_tension/widgets/organismo_card_resumen.dart';
import 'package:mi_tension/widgets/organismo_card_sinInformacion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = EstadisticasService();

  EstadisticasDto? _estadisticas;
  List<PresionRegistroDto> _historial = [];
  bool _cargando = true;
  String? _error;
  String? _nombre;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarNombre() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;
    final payload = token.split('.')[1];
    final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    final json = jsonDecode(decoded);
    if (!mounted) return;
    setState(() => _nombre = json['nombre']);
  }

  Future<void> _cargarDatos() async {
    if (!mounted) return;
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _cargarNombre();
      final historial = await _service.getHistorialConAnalisis();
      final estadisticas = await _service.getEstadisticas();

      if (!mounted) return;
      setState(() {
        _historial = historial;
        _estadisticas = estadisticas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoleculaAppBarPrincipal(titulo: "Inicio"),
      body: _cargando
          ? const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(),
              ),
            )
          : _error != null
          ? Center(
              child: OrganismoCardSininformacion(
                descripcion: "Comprueba tu conexión e inténtalo de nuevo",
              ),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _cargarDatos,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 80,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          AtomoTextoDescripcion(
                            titulo: "Un gusto verte, ${_nombre ?? 'amigo'}! 👋",
                          ),
                          const SizedBox(height: 10),
                          if (_historial.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: OrganismoCardSininformacion(
                                  descripcion:
                                      "Empieza añadiendo información para realizar tu seguimiento",
                                ),
                              ),
                            )
                          else ...[
                            const Text("Tu último registro:"),
                            MoleculaCardRegistro(registro: _historial.first),
                            const SizedBox(height: 20),
                            OrganismoCardGraficos(historial: _historial),
                            const SizedBox(height: 24),
                            if (_estadisticas != null)
                              OrganismoCardResumen(
                                estadisticas: _estadisticas!,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
