import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';



void main(){
  runApp(
    ProviderScope(child: App())
  );
}
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final colorTheme = ref.watch(selectColorThemeProvider);
    final isDark = ref.watch(isDarkThemeProvider);
    return MaterialApp.router(
      theme: AppTheme(
        isDark: isDark,
        selectedColor: colorTheme
      ).getTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      
    );
  }
}