class Quote {
  GlobalQuote globalQuote;

  Quote({this.globalQuote});

  Quote.fromJson(Map<String, dynamic> json) {
    globalQuote = json['Global Quote'] != null
        ? new GlobalQuote.fromJson(json['Global Quote'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.globalQuote != null) {
      data['Global Quote'] = this.globalQuote.toJson();
    }
    return data;
  }
}

class GlobalQuote {
  String symbol;
  double open;
  double high;
  double low;
  double price;
  int volume;
  DateTime latestTradingDay;
  double previousClose;
  double change;
  String changePercent;

  GlobalQuote(
      {this.symbol,
        this.open,
        this.high,
        this.low,
        this.price,
        this.volume,
        this.latestTradingDay,
        this.previousClose,
        this.change,
        this.changePercent});

  GlobalQuote.fromJson(Map<String, dynamic> json) {
    symbol = json['01. symbol'];
    open = double.parse(json['02. open']);
    high = double.parse(json['03. high']);
    low = double.parse(json['04. low']);
    price = double.parse(json['05. price']);
    volume = int.parse(json['06. volume']);
    latestTradingDay = DateTime.parse(json['07. latest trading day']);
    previousClose = double.parse(json['08. previous close']);
    change = double.parse(json['09. change']);
    changePercent = json['10. change percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['01. symbol'] = this.symbol;
    data['02. open'] = this.open;
    data['03. high'] = this.high;
    data['04. low'] = this.low;
    data['05. price'] = this.price;
    data['06. volume'] = this.volume;
    data['07. latest trading day'] = this.latestTradingDay;
    data['08. previous close'] = this.previousClose;
    data['09. change'] = this.change;
    data['10. change percent'] = this.changePercent;
    return data;
  }
}