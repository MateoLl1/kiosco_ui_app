



import 'package:kiosco_au/domain/domain.dart';

abstract class AgenciasRepository {

  Future<List<Agencia>> getAgencias();
  
}