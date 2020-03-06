import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:portfolio_follow/models/asset.dart';

const String _tableName = 'asset';
const String _id = 'id';
const String _symbol = 'symbol';
const String _quantity = 'quantity';
const String _exchange = 'exchange';

Future<Database> createTable() async {
  final String path = await getDatabasesPath();
  final String name = 'portfolio.db';

  final String fullPath = join(path, name);

  return openDatabase(fullPath, onCreate: (db, version) {
    db.execute('CREATE TABLE $_tableName('
        '$_id INTEGER PRIMARY KEY, '
        '$_symbol TEXT, '
        '$_quantity INTEGER, '
        '$_exchange TEXT)');
  }, version: 1);
}

Future<int> insert(Asset asset) async {
  final Database db = await createTable();

  return db.insert(_tableName, _toMap(asset));
}

Future<int> delete(int assetId) async {
  final Database db = await createTable();

  return db.delete(_tableName, where: '$_id = ?', whereArgs: [assetId]);
}

Future<List<Asset>> selectAll() async {
  final Database db = await createTable();
  final List<Map<String, dynamic>> assets = await db.query(_tableName);

  return _toList(assets);
}

Map<String, dynamic> _toMap(Asset asset) {
  Map<String, dynamic> values = Map();

  values[_symbol] = asset.symbol;
  values[_quantity] = asset.quantity;
  values[_exchange] = asset.exchange;

  return values;
}

List<Asset> _toList(List<Map<String, dynamic>> assets) {
  final List<Asset> result = List();

  for (Map<String, dynamic> asset in assets) {
    result.add(Asset(
      id: asset[_id],
      symbol: asset[_symbol],
      quantity: asset[_quantity],
      exchange: asset[_exchange]
    ));
  }
  return result;
}
