import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:portfolio_follow/models/asset.dart';

Future<Database> createTable() async {
  final String path = await getDatabasesPath();
  final String name = 'portfolio.db';

  final String fullPath = join(path, name);

  return openDatabase(fullPath, onCreate: (db, version) {
    db.execute('CREATE TABLE asset('
        'id INTEGER PRIMARY KEY, '
        'symbol TEXT, '
        'quantity INTEGER)');
  }, version: 1);
}

Future<int> insert(Asset asset) async {
  final Database db = await createTable();

  Map<String, dynamic> values = Map();

  values['symbol'] = asset.symbol;
  values['quantity'] = asset.quantity;

  return db.insert('asset', values);
}

Future<int> delete(int assetId) async {
  final Database db = await createTable();

  return db.delete('asset', where: 'id = ?', whereArgs: [assetId]);
}

Future<List<Asset>> selectAll() async {
  final Database db = await createTable();
  final List<Map<String, dynamic>> assets = await db.query('asset');
  final List<Asset> result = List();

  for (Map<String, dynamic> asset in assets) {
    result.add(Asset(
      id: asset['id'],
      symbol: asset['symbol'],
      quantity: asset['quantity'],
    ));
  }

  return result;
}
