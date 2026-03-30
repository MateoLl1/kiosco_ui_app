import 'package:isar_community/isar.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return Isar.open(
        [AppSessionConfigSchema],
        directory: dir.path,
        inspector: true,
        name: 'kiosco_au_db',
      );
    }

    return Isar.getInstance('kiosco_au_db')!;
  }

  @override
  Future<void> clearSession() async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.appSessionConfigs.delete(1);
    });
  }

  @override
  Future<AppSessionConfig?> getSession() async {
    final isar = await db;
    return isar.appSessionConfigs.get(1);
  }

  @override
  Future<bool> saveSession(AppSessionConfig session) async {
    final isar = await db;

    session.id = 1;

    await isar.writeTxn(() async {
      await isar.appSessionConfigs.put(session);
    });

    return true;
  }
}
