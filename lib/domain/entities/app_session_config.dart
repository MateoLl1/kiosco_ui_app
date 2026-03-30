import 'package:isar_community/isar.dart';

part 'app_session_config.g.dart';

enum AppRole {
  guardia,
  kiosco,
  turnero,
  admin,
}

@collection
class AppSessionConfig {
  Id id = 1;

  int? agenciaId;

  @Enumerated(EnumType.name)
  AppRole role = AppRole.guardia;

  AppSessionConfig({
    this.agenciaId = 0,
    this.role = AppRole.admin,
  });
}