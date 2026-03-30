import 'package:kiosco_au/domain/domain.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<void> clearSession() {
    return datasource.clearSession();
  }

  @override
  Future<AppSessionConfig?> getSession() {
    return datasource.getSession();
  }

  @override
  Future<bool> saveSession(AppSessionConfig session) {
    return datasource.saveSession(session);
  }
}
