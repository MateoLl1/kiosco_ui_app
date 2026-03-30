

import 'package:kiosco_au/domain/domain.dart';

abstract class TurnosDatasource {
  

  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId);

}