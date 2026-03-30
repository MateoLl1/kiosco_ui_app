
import 'package:kiosco_au/domain/domain.dart';

abstract class LocalStorageRepository {
  
  Future<bool> saveSession(AppSessionConfig session);

  Future<AppSessionConfig?> getSession();

  Future<void> clearSession();
}

