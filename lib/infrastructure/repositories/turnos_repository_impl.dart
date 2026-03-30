

import 'package:kiosco_au/domain/domain.dart';

class TurnosRepositoryImpl extends TurnosRepository {


  final TurnosDatasource datasource;

  TurnosRepositoryImpl({required this.datasource});


  @override
  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId) {
    return datasource.getPantallaTurnos(agenciaId);
  }
  
}