


import 'package:kiosco_au/domain/domain.dart';

class AuthTokenRepositoryImpl extends AuthRepository {
  
  final AuthDatasource datasource;
  
  AuthTokenRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<AuthTokenResponse> getAuthToken() {
    return datasource.getAuthToken();
  }
  
}