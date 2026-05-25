import 'package:flutter/material.dart';
import 'package:mi_tension/features/screens/home_screen.dart';
import 'package:mi_tension/features/screens/records_screen.dart';
import 'package:mi_tension/features/screens/reminders_screen.dart';
import 'package:mi_tension/features/screens/settings_screen.dart';
import 'package:mi_tension/features/theme/app_theme.dart';
import 'package:mi_tension/widgets/molecula_FabSpeedDial_Principal.dart';

class OrganismoHomeMenuPrincipal extends StatefulWidget {
  final int indiceActual;
  const OrganismoHomeMenuPrincipal({super.key, this.indiceActual = 0});

  @override
  State<OrganismoHomeMenuPrincipal> createState() =>
      _OrganismoHomeMenuPrincipalState();
}

class _OrganismoHomeMenuPrincipalState
    extends State<OrganismoHomeMenuPrincipal> {
  late int indiceSeleccionado;

  final List<Widget> _pantallas = [
    const HomeScreen(),
    const RecordsScreen(),
    const RemindersScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    indiceSeleccionado = widget.indiceActual;
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label, int index) {
    final bool seleccionado = index == indiceSeleccionado;
    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: seleccionado ? AppTheme.darkerBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _pantallas[indiceSeleccionado],
      floatingActionButton: MoleculaFabspeeddialPrincipal(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceSeleccionado,
        onTap: (indice) => setState(() => indiceSeleccionado = indice),
        selectedItemColor: AppTheme.whiteTextBackground,
        unselectedItemColor: AppTheme.whiteTextBackground.withOpacity(0.6),
        backgroundColor: AppTheme.primaryBlue,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        items: [
          _buildItem(Icons.home, "Inicio", 0),
          _buildItem(Icons.favorite_border, "Historial", 1),
          _buildItem(Icons.notifications_none, "Recordatorios", 2),
          _buildItem(Icons.settings, "Configuración", 3),
        ],
      ),
    );
  }
}
