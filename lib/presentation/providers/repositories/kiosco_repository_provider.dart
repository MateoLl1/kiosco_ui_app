


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

final kioscoRepositoryProvider = Provider<KioscoRepository>((ref) {
  return KioscoRepositoryImpl(datasource: KioscoDatasourceImpl());
});