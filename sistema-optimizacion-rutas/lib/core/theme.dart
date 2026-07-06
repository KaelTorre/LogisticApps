import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Esquema shadcn/ui azul: paleta profesional, minimalista y de alto
/// contraste, consistente en modo claro y oscuro.
const FlexScheme _esquema = FlexScheme.shadBlue;

ThemeData buildLightTheme() {
  return FlexThemeData.light(
    scheme: _esquema,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 6,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: false,
      useM2StyleDividerInM3: false,
      defaultRadius: 12,
      elevatedButtonSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: VisualDensity.standard,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
  );
}

ThemeData buildDarkTheme() {
  return FlexThemeData.dark(
    scheme: _esquema,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 14,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: false,
      defaultRadius: 12,
      elevatedButtonSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: VisualDensity.standard,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
  );
}
