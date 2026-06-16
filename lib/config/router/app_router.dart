import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/screens.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

Widget withHiddenAdminAccess(BuildContext context, Widget child) {
  return HiddenAdminAccess(
    onTriggered: () {
      context.push('/close-session');
    },
    child: child,
  );
}

final appRouter = GoRouter(
  initialLocation: '/mostrador',
  // initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        LoadingScreen(),
      ),
    ),
    GoRoute(
      path: '/ingresar-placa',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        IngresarPlacaScreen(),
      ),
    ),
    GoRoute(
      path: '/ingresar-ruc',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        IngresarRucScreen(),
      ),
    ),
    GoRoute(
      path: '/turno-asignado',
      builder: (context, state) {
        return withHiddenAdminAccess(
          context,
          TurnoAsignadoScreen(extra: state.extra),
        );
      },
    ),
    GoRoute(
      path: '/config',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        ConfigScreen(),
      ),
    ),
    GoRoute(
      path: '/close-session',
      builder: (context, state) => CloseSessionScreen(),
    ),
    GoRoute(
      path: '/tipo-atencion',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        TipoAtencionScreen(),
      ),
    ),
    GoRoute(
      path: '/bienvenida-usuario',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        BienvenidaUsuarioScreen(),
      ),
    ),
    GoRoute(
      path: '/pantalla-turnos',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        TurneroWaitingScreen(),
      ),
    ),
    GoRoute(
      path: '/guardia',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        GuardiaScreen(),
      ),
    ),
    GoRoute(
      path: '/mostrador',
      builder: (context, state) => withHiddenAdminAccess(
        context,
        MostradorScreen(),
      ),
    ),
  ],
);