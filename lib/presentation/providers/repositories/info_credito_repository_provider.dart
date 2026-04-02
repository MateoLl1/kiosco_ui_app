import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

final infoCreditoRepositoryProvider = Provider<InfoCreditoRepository>((ref) {
  return InfoCreditoRepositoryImpl(
    datasource: DataBookDatasource(),
  );
});