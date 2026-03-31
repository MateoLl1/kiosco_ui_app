import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurneroAdPlaceholder extends StatefulWidget {
  final List<Turno> recienLlamados;

  const TurneroAdPlaceholder({
    super.key,
    required this.recienLlamados,
  });

  @override
  State<TurneroAdPlaceholder> createState() => _TurneroAdPlaceholderState();
}

class _TurneroAdPlaceholderState extends State<TurneroAdPlaceholder> {
  final PageController pageController = PageController();
  Timer? timerPublicidad;
  int paginaActual = 0;

  final List<String> imagenesPublicidad = [
    'assets/img/ads/chevrolet-ad-1.jpg',
    'assets/img/ads/chevrolet-ad-2.jpg',
    'assets/img/ads/chevrolet-ad-3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _iniciarRotacion();
  }

  @override
  void dispose() {
    timerPublicidad?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void _iniciarRotacion() {
    if (imagenesPublicidad.length <= 1) return;

    timerPublicidad = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !pageController.hasClients) return;

      final siguientePagina =
          paginaActual + 1 >= imagenesPublicidad.length ? 0 : paginaActual + 1;

      pageController.animateToPage(
        siguientePagina,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
        ),
        color: colors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: imagenesPublicidad.isEmpty
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.surface,
                    colors.primary.withValues(alpha: 0.08),
                    colors.secondary.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      'ESPACIO PUBLICITARIO',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aquí puedes mostrar campañas,\nimágenes o videos mientras\nlos clientes esperan.',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 30,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'No hay imágenes configuradas.',
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imagenesPublicidad.length,
                    onPageChanged: (index) {
                      setState(() {
                        paginaActual = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imagenesPublicidad[index],
                        fit: BoxFit.fill,

                        errorBuilder: (_, _, _) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colors.surface,
                                  colors.primary.withValues(alpha: 0.08),
                                  colors.secondary.withValues(alpha: 0.08),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  'ESPACIO PUBLICITARIO',
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No se pudo cargar la imagen publicitaria.',
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 30,
                                    height: 1.25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  imagenesPublicidad[index],
                                  style: TextStyle(
                                    color: colors.onSurface.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imagenesPublicidad.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: paginaActual == index ? 24 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: paginaActual == index
                              ? colors.primary
                              : Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}