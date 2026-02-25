

import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: '/loading',
      builder: (context, state) => LoadingScreen(),
    ),

    GoRoute(
      path: '/taller-servicio',
      builder: (context, state) => TallerServicioScreen(),
    ),

    GoRoute(
      path: '/ingresar-placa',
      builder: (context, state) => IngresarPlacaScreen(),
    ),
    GoRoute(
      path: '/ingresar-ruc',
      builder: (context, state) => IngresarRucScreen(),
    ),

    GoRoute(
      path: '/turno-asignado',
      builder: (context, state) => TurnoAsignadoScreen(),
    ),
  ]
);