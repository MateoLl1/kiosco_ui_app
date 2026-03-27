


import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';



class AgenciasAutoconsaDatasource implements AgenciasDatasource {
  

  final _dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
    ),
  );

  
  @override
  Future<List<Agencia>> getAgencias() async{
    final response = await _dio.get('/agencias');
    final List<dynamic> data = response.data;
    final List<Agencia> agencias = data.map((json) => AgenciaMapper.agenciaToEntity(json)).toList();
    return agencias;
  }
  
}