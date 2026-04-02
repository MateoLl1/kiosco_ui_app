


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthTokenRepositoryImpl(datasource: AutoconsaAuthDatasource());
});