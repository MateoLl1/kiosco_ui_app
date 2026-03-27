

import 'package:kiosco_au/domain/domain.dart';

abstract class AgenciasDatasource {

  Future<List<Agencia>> getAgencias();
  
}