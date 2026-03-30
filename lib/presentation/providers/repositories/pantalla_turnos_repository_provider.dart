


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';
import 'package:kiosco_au/domain/domain.dart';

final pantallaTurnosRepositoryProvider = Provider<TurnosRepository>((ref) {
  return TurnosRepositoryImpl(datasource: TurnosAutoconsaDatasource());
});