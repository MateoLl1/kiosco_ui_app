

import 'package:kiosco_au/domain/domain.dart';

abstract class TurnosRepository {
  

  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId);

}