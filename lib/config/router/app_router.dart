

import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: '/loading',
      builder: (context, state) => LoadingScreen(),
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

    GoRoute(
      path: '/config',
      builder: (context, state) => ConfigScreen(),
    ),

    GoRoute(
      path: '/tipo-atencion',
      builder: (context, state) => TipoAtencionScreen(),
    ),

    GoRoute(
      path: '/bienvenida-usuario',
      builder: (context, state) => BienvenidaUsuarioScreen(),
    ),
  ]
);