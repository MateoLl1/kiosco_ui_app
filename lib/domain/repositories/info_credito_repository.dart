

import 'package:kiosco_au/domain/domain.dart';

abstract class InfoCreditoRepository {
  Future<Databook> getPerfilDatabook({
    required String token,
    required String identificacion,
    required int empresa,
  });
}