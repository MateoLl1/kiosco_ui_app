




import 'package:kiosco_au/domain/domain.dart';

abstract class AuthRepository  {
  

  Future<AuthTokenResponse> getAuthToken();

}