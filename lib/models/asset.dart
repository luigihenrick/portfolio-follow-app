import 'package:portfolio_follow/models/exchange.dart';

class Asset {
  int id;
  String symbol;
  int quantity;
  Exchange exchange;

  Asset({
    this.id,
    this.symbol,
    this.quantity,
    this.exchange,
  });
}
