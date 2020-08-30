class AssetCustomer {
  int id;
  String symbol;
  OperationType type;
  int quantity;
  DateTime operationDate;
  double price;
  DateTime priceUpdated;

  AssetCustomer(
      {this.id,
      this.symbol,
      this.quantity,
      this.operationDate,
      this.price,
      this.priceUpdated});
}

enum OperationType { C, V }
