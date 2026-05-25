import 'package:flutter/material.dart';
import 'package:mi_tension/features/screens/create_record_screen.dart';
import 'package:mi_tension/features/screens/create_reminder_screen.dart';
import 'package:mi_tension/widgets/atomo_label_opcion.dart';

class MoleculaFabspeeddialPrincipal extends StatefulWidget {
  const MoleculaFabspeeddialPrincipal({super.key});

  @override
  State<MoleculaFabspeeddialPrincipal> createState() =>
      _MoleculaFabspeeddialPrincipalState();
}

class _MoleculaFabspeeddialPrincipalState
    extends State<MoleculaFabspeeddialPrincipal> {
  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_abierto) ...[
          AtomoLabelOpcion(
            label: "Registrar medición",
            onTap: () {
              setState(() => _abierto = false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateRecordScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          AtomoLabelOpcion(
            label: "Crear recordatorio",
            onTap: () {
              setState(() => _abierto = false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateReminderScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _abierto = !_abierto),
          child: AnimatedRotation(
            turns: _abierto ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
