class PriceHistoryDaily {
  MetaData metaData;
  List<DailyTimeSeries> dailyTimeSeries;

  PriceHistoryDaily({this.metaData, this.dailyTimeSeries});

  PriceHistoryDaily.fromJson(Map<String, dynamic> json) {
    metaData = json['Meta Data'] != null ? new MetaData.fromJson(json['Meta Data']) : null;
    dailyTimeSeries = json['Time Series (Daily)'] != null ? DailyTimeSeries.fromJson(json['Time Series (Daily)']) : null;
  }
}

class MetaData {
  String information;
  String symbol;
  String lastRefreshed;
  String timeZone;

  MetaData({this.information, this.symbol, this.lastRefreshed, this.timeZone});

  MetaData.fromJson(Map<String, dynamic> json) {
    information = json['1. Information'];
    symbol = json['2. Symbol'];
    lastRefreshed = json['3. Last Refreshed'];
    timeZone = json['4. Time Zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1. Information'] = this.information;
    data['2. Symbol'] = this.symbol;
    data['3. Last Refreshed'] = this.lastRefreshed;
    data['4. Time Zone'] = this.timeZone;
    return data;
  }
}

class DailyTimeSeries {
  DateTime date;
  double open;
  double high;
  double low;
  double close;
  double volume;

  DailyTimeSeries({this.date, this.open, this.high, this.low, this.close, this.volume});

  static List<DailyTimeSeries> fromJson(Map<String, dynamic> json) {
    var dates = json.keys.toList();
    var values = json.values.toList();
    List<DailyTimeSeries> allData = new List<DailyTimeSeries>();

    for(var i = 0; i < dates.length; i++){
      allData.add(DailyTimeSeries(
        date: DateTime.parse(dates[i]),
        open : double.parse(values[i]['1. open']),
        high : double.parse(values[i]['2. high']),
        low : double.parse(values[i]['3. low']),
        close : double.parse(values[i]['4. close']),
        volume : double.parse(values[i]['5. volume']),
      ));
    }

    return allData;
  }
}