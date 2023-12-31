import 'package:flutter/material.dart';

const colorSeed = Color(0xff031329);

//const scaffoldBackgroundColor = Colors.white;

class AppTheme {
  ThemeData getTheme() => ThemeData(
        ///* General
        useMaterial3: true,
        colorSchemeSeed: colorSeed,
        fontFamily: 'Raleway-Bold',

        ///* Texts
/*     textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 20 )
    ), */

        ///* Scaffold Background Color
        //scaffoldBackgroundColor: scaffoldBackgroundColor,

        ///* Buttons
        /* filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
        /* textStyle: MaterialStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          ) */
      )
    ), */

        ///* AppBar
/*     appBarTheme: const AppBarTheme(
      color: scaffoldBackgroundColor,
      /* titleTextStyle: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ), */
    ) */
      );
}
