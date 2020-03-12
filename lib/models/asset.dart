class Asset {
  int id;
  String symbol;
  OperationType type;
  int quantity;
  DateTime operationDate;
  double price;
  DateTime priceUpdated;

  Asset(
      {this.id,
      this.symbol,
      this.quantity,
      this.operationDate,
      this.price,
      this.priceUpdated});
}

enum OperationType { C, V }
