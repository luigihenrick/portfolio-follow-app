import 'package:portfolio_follow/models/quote.dart';
import 'package:portfolio_follow/services/alpha_vantage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:portfolio_follow/models/asset.dart';
import 'package:portfolio_follow/database/app_database.dart';

class AssetDao {
  static const String _tableName = 'asset';
  static const String _id = 'id';
  static const String _symbol = 'symbol';
  static const String _quantity = 'quantity';
  static const String _operationDate = 'operation_date';
  static const String _price = 'price';
  static const String _priceUpdated = 'price_updated';

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_symbol TEXT, '
      '$_quantity INTEGER, '
      '$_operationDate TEXT, '
      '$_price DECIMAL, '
      '$_priceUpdated TEXT)';

  Future<int> insert(Asset asset) async {
    final Database db = await getDatabase();

    return db.insert(_tableName, _toMap(asset));
  }

  Future<int> update(Asset asset) async {
    final Database db = await getDatabase();

    return db.update(_tableName, _toMap(asset),
        where: '$_id = ?', whereArgs: [asset.id]);
  }

  Future<int> delete(int assetId) async {
    final Database db = await getDatabase();

    return db.delete(_tableName, where: '$_id = ?', whereArgs: [assetId]);
  }

  Future<List<Asset>> selectAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> assets = await db.query(_tableName);

    return _toList(assets);
  }

  Map<String, dynamic> _toMap(Asset asset) {
    Map<String, dynamic> values = Map();

    values[_symbol] = asset.symbol.trim();
    values[_quantity] = asset.quantity;
    values[_operationDate] = asset.operationDate != null
        ? dateFormat.format(asset.operationDate)
        : null;
    values[_price] = asset.price;
    values[_priceUpdated] = asset.priceUpdated != null
        ? dateFormat.format(asset.priceUpdated)
        : null;

    return values;
  }

  List<Asset> _toList(List<Map<String, dynamic>> assets) {
    final List<Asset> result = List();

    for (Map<String, dynamic> asset in assets) {
      result.add(Asset(
        id: asset[_id],
        symbol: asset[_symbol],
        quantity: asset[_quantity],
        operationDate: DateTime.tryParse(asset[_operationDate] ?? ''),
        price: asset[_price] is int ? asset[_price].toDouble() : asset[_price],
        priceUpdated: DateTime.tryParse(asset[_priceUpdated] ?? ''),
      ));
    }
    return result;
  }

  Future<List<Asset>> selectAllWithPrices() async {
    AssetDao _dao = AssetDao();
    List<Asset> result = List();

    for (Asset asset in await _dao.selectAll()) {
      if (asset.priceUpdated == null ||
          asset.price == null ||
          DateTime.now().difference(asset.priceUpdated).inMinutes > 15) {
        Quote quote = await AlphaVantageService.fetchQuoteData(asset.symbol);
        asset.price = quote?.globalQuote?.price;
        asset.priceUpdated = DateTime.now();
        _dao.update(asset);
      }
      result.add(asset);
    }

    return result;
  }
}
