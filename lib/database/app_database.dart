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
        'name TEXT, '
        'quantity INTEGER)');
  }, version: 1);
}

Future<int> insert(Asset asset) async {
  final Database db = await createTable();

  Map<String, dynamic> values = Map();

  values['name'] = asset.name;
  values['quantity'] = asset.quantity;

  return db.insert('asset', values);
}

Future<List<Asset>> selectAll() async {
  final Database db = await createTable();

  var assets = await db.query('asset');
  return assets.map((a) => Asset(
        id: a['id'],
        name: a['name'],
        quantity: a['quantity'],
      ));
}
