import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class MoleculaAppBarPrincipal extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;
  final bool showBackButton;

  const MoleculaAppBarPrincipal({
    super.key,
    required this.titulo,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      toolbarHeight: 100,
      iconTheme: const IconThemeData(color: AppTheme.whiteTextBackground),
      automaticallyImplyLeading:
          false, // quitamos el botón automático de Flutter
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(top: 40),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Estás seguro?'),
                    content: const Text('Si es así perderás tu progreso.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          titulo,
          textAlign: showBackButton ? TextAlign.start : TextAlign.center,
          style: const TextStyle(
            color: AppTheme.whiteTextBackground,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: !showBackButton,
    );
  }
}
