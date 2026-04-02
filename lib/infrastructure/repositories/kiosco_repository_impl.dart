


import 'package:kiosco_au/domain/domain.dart';

class KioscoRepositoryImpl extends KioscoRepository {
  
  final KioscoDatasource datasource;

  KioscoRepositoryImpl({required  this.datasource});
  
  
  @override
  Future<List<Agencia>> getAgencias() {
    return datasource.getAgencias();
  }

  @override
  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId) {
    return datasource.getPantallaTurnos(agenciaId);
  }
  
}