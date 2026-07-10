import 'package:flutter/material.dart';

/// Expone el color crudo elegido en `colorsAppTheme` (sin los ajustes de tono
/// que aplica Material 3 a `colorScheme.primary`), para usarlo donde se quiera
/// ver exactamente ese color (ej. fondos decorativos).
class AppSeedColorTheme extends ThemeExtension<AppSeedColorTheme> {
  final Color seed;

  const AppSeedColorTheme({this.seed = Colors.blue});

  @override
  AppSeedColorTheme copyWith({Color? seed}) {
    return AppSeedColorTheme(seed: seed ?? this.seed);
  }

  @override
  ThemeExtension<AppSeedColorTheme> lerp(
    covariant ThemeExtension<AppSeedColorTheme>? other,
    double t,
  ) {
    if (other is! AppSeedColorTheme) return this;
    return AppSeedColorTheme(seed: Color.lerp(seed, other.seed, t)!);
  }
}
