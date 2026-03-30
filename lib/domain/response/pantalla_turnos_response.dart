import 'package:kiosco_au/domain/domain.dart';

class PantallaTurnosResponse {
  final List<Turno> turnos;
  final Turno? turnoActual;
  final List<Turno> turnosRecienLlamados;
  final List<Turno> turnosPendientes;

  PantallaTurnosResponse({
    required this.turnos,
    required this.turnoActual,
    required this.turnosRecienLlamados,
    required this.turnosPendientes,
  });
}