

import 'package:kiosco_au/domain/domain.dart';

class AgenciasRepositoryImpl extends AgenciasRepository {

  final AgenciasDatasource datasource;

  AgenciasRepositoryImpl({required this.datasource});

  @override
  Future<List<Agencia>> getAgencias() {
    return datasource.getAgencias();
  }
  
}