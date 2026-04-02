import 'package:kiosco_au/domain/domain.dart';

class InfoCreditoRepositoryImpl extends InfoCreditoRepository {
  final InfoCreditoDatasource datasource;

  InfoCreditoRepositoryImpl({required this.datasource});

  @override
  Future<Databook> getPerfilDatabook({
    required String token,
    required String identificacion,
    required int empresa,
  }) {
    return datasource.getPerfilDatabook(
      token: token,
      identificacion: identificacion,
      empresa: empresa,
    );
  }
}