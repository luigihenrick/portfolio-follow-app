import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:portfolio_follow/database/dao/asset_dao.dart';
import 'package:sqflite/sqflite.dart';

final DateFormat dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

Future<Database> getDatabase() async {
  final String path = await getDatabasesPath();
  final String name = 'portfolio.db';

  final String fullPath = join(path, name);

  return openDatabase(fullPath, onCreate: (db, version) {
    db.execute(AssetDao.tableSql);
  }, onDowngrade: onDatabaseDowngradeDelete, version: 1);
}
