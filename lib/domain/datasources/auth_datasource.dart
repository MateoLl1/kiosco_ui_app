


import 'package:kiosco_au/domain/domain.dart';

abstract class AuthDatasource  {
  

  Future<AuthTokenResponse> getAuthToken();

}