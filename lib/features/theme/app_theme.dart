import 'package:flutter/material.dart';

///
/// Esta es la configuracion del tema base, en este caso solo tendremos lightTheme
///

//Paleta de colores para la galeria de widgets
class AppTheme {
  //PALETA PRINCIPAL
  static const Color primaryBlue = Color(0xFF0A84FF);
  static const Color mainTitleBlack = Color(0xFF000000);
  static const Color descriptionGray = Color(0xFF888484);
  static const Color whiteTextBackground = Color(0xFFFFFFFF);

  //COMPLEMENTARIOS
  static const Color buttonGreen = Color(0xFF34C759);
  static const Color buttonOrange = Color(0xFFFF9F0A);
  static const Color buttonRed = Color(0xFFFF3B30);
  static const Color transparent = Color(0x00000000);
  static const Color darkerBlue = Color(0xFF0066CC);

  //FONDOS
  static const Color backgroundGreen = Color(0xFFE6FCEB);
  static const Color backgroundOrange = Color(0xFFFFF9E1);
  static const Color backgroundRed = Color(0xFFFFE7E7);
  static const Color backgroundGrey = Color(0xFFF3F3F3);

  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: mainTitleBlack,
        surface: whiteTextBackground,
      ),
      fontFamily: 'sf',
      useMaterial3: true,
      scaffoldBackgroundColor: whiteTextBackground,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
