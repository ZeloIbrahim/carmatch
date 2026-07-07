import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const asphalte = Color(0xFF14151A); // fond principal
  static const beton = Color(0xFF1E2027); // surfaces / cartes
  static const betonClair = Color(0xFF282B34); // surfaces surelevees (chips, inputs)
  static const brouillard = Color(0xFF9AA0AC); // texte secondaire
  static const blancPhare = Color(0xFFF5F6F8); // texte principal
  static const ignition = Color(0xFFFF6A3D); // accent primaire (CTA, score haut)
  static const ignitionSombre = Color(0xFFCC4E27);
  static const vertEligible = Color(0xFF3DDC97); // eligibilite / score haut
  static const ambre = Color(0xFFFFC24B); // score moyen
  static const rougeAlerte = Color(0xFFFF5C5C); // score bas
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData.dark();
    final displayFont = GoogleFonts.oswald;
    final bodyFont = GoogleFonts.inter;

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.asphalte,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.beton,
        primary: AppColors.ignition,
        secondary: AppColors.vertEligible,
        onSurface: AppColors.blancPhare,
        onPrimary: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: displayFont(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.blancPhare,
          letterSpacing: 0.5,
        ),
        titleLarge: displayFont(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.blancPhare,
        ),
        titleMedium: displayFont(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.blancPhare,
        ),
        bodyLarge: bodyFont(fontSize: 15, color: AppColors.blancPhare),
        bodyMedium: bodyFont(fontSize: 14, color: AppColors.brouillard),
        labelLarge: bodyFont(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.ignition,
          letterSpacing: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.asphalte,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: displayFont(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.blancPhare,
          letterSpacing: 0.5,
        ),
      ),
      cardColor: AppColors.beton,
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: AppColors.ignition,
        inactiveTrackColor: AppColors.betonClair,
        thumbColor: AppColors.ignition,
        overlayColor: AppColors.ignition.withOpacity(0.15),
        valueIndicatorColor: AppColors.ignition,
        valueIndicatorTextStyle: bodyFont(color: Colors.white, fontSize: 12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.vertEligible : AppColors.brouillard,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.vertEligible.withOpacity(0.4)
              : AppColors.betonClair,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.betonClair,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ignition,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: displayFont(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.betonClair,
        selectedColor: AppColors.ignition,
        labelStyle: bodyFont(color: AppColors.blancPhare, fontSize: 13),
        secondaryLabelStyle: bodyFont(color: Colors.white, fontSize: 13),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  /// Couleur du score selon sa valeur (0-100), utilisee par la jauge.
  static Color scoreColor(int score) {
    if (score >= 70) return AppColors.vertEligible;
    if (score >= 45) return AppColors.ambre;
    return AppColors.rougeAlerte;
  }

  /// Associe une couleur de voiture (texte FR) a une teinte pour l'illustration.
  static Color couleurVoiture(String couleur) {
    switch (couleur) {
      case "Blanc":
        return const Color(0xFFE8E9EC);
      case "Noir":
        return const Color(0xFF2B2D33);
      case "Gris anthracite":
        return const Color(0xFF5B6270);
      case "Bleu":
        return const Color(0xFF3B6FE0);
      case "Rouge":
        return const Color(0xFFD8453B);
      case "Beige":
        return const Color(0xFFD6C4A3);
      case "Vert":
        return const Color(0xFF3E8E5C);
      case "Marron":
        return const Color(0xFF6B4A34);
      default:
        return AppColors.brouillard;
    }
  }

  /// Icone selon la carrosserie, pour l'illustration de secours.
  static IconData iconeCarrosserie(String carrosserie) {
    switch (carrosserie) {
      case "SUV":
      case "SUV coupe":
        return Icons.directions_car_filled;
      case "berline":
        return Icons.directions_car;
      case "monospace":
      case "familiale":
        return Icons.airport_shuttle;
      case "compacte":
      case "citadine":
      default:
        return Icons.directions_car;
    }
  }
}
