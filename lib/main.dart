import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(
    MaterialApp(
      title: 'Portfolio',
      home: PageState(title: 'Minha Carteira', animate: true),
    )
);

class PageState extends StatefulWidget{
  final String title;
  final bool animate;

  PageState({Key key, this.title, this.animate}) : super(key: key);

  @override
  _PageState createState() => _PageState();

}

class _PageState extends State<PageState>{
  static List<DonutChartItem> _chartData = DonutChart._createSampleData();

  int _currentPage = 0;
  Future<Quote> _futureQuote = fetchQuote();
  Future<PriceHistoryDaily> _futurePriceHistoryDaily;

  void updateData(){
    setState(() {
      //_futureQuote = fetchQuote();
      _chartData = DonutChart._createSampleData();
      renderPage(_currentPage);
    });
  }

  void _onChangePage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureQuote = fetchQuote();
    _futurePriceHistoryDaily = fetchPriceHistoryDaily();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: Colors.white,
      body: renderPage(_currentPage),
      floatingActionButton: FloatingActionButton(
        onPressed: updateData,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), title: Text('Carteira')),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), title: Text('Rentabilidade')),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), title: Text('Cotações')),
        ],
        currentIndex: _currentPage,
        selectedItemColor: Colors.blue[700],
        onTap: _onChangePage,
      ),
    );
  }

  Widget renderPage(int index){
    switch(index){
      case 1:
        return HistoryPage(_futurePriceHistoryDaily, animate: widget.animate); //HistoryPage(_futurePriceHistoryDaily);
      case 2:
        return QuotePage(_futureQuote);
      default:
        return WalletPage(_chartData, animate: widget.animate);
    }
  }
}

/* ---------------------------------------------------------------------------------------------------------------------------------------
*  --------------------------------------------------------------- Pages -----------------------------------------------------------------
*  ---------------------------------------------------------------------------------------------------------------------------------------
* */

class WalletPage extends StatelessWidget {
  final List<DonutChartItem> chartData;
  final bool animate;

  WalletPage(this.chartData, {this.animate});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          'Patrimônio: ${chartData.map((i) => i.value).reduce((acc, item) => acc + item)} K',
          style: TextStyle(fontSize: 25, color: Colors.grey),
        ),
        new Padding(
          padding: new EdgeInsets.all(32.0),
          child: new SizedBox(
            height: 400.0,
            child: DonutChart(
              'Stocks Allocation',
              chartData,
              animate: animate,
            ),
          ),
        )
      ],
    );
  }
}

class QuotePage extends StatelessWidget{
  final Future<Quote> futureQuote;

  QuotePage(this.futureQuote);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: futureQuote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text('${snapshot.data.globalQuote.symbol} - ${snapshot.data.globalQuote.price}', style: TextStyle(fontSize: 25, color: Colors.grey))
          ]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class HistoryPage extends StatelessWidget{
  final bool animate;

  final Future<PriceHistoryDaily> futurePriceHistoryDaily;

  HistoryPage(this.futurePriceHistoryDaily, {this.animate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PriceHistoryDaily>(
      future: futurePriceHistoryDaily,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Ativo: ${snapshot.data.metaData.symbol}',
                style: TextStyle(fontSize: 25, color: Colors.grey),
              ),
              new Padding(
                padding: new EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: new SizedBox(
                  height: 400.0,
                  child: LineChart(
                    'History Prices',
                    snapshot.data.dailyTimeSeries.map((item) => new LineChartItem(item.date, item.close)).toList(),
                    animate: animate,
                  ),
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

/* ---------------------------------------------------------------------------------------------------------------------------------------
*  --------------------------------------------------------------- Quote -----------------------------------------------------------------
*  ---------------------------------------------------------------------------------------------------------------------------------------
* */

Future<Quote> fetchQuote() async {
  final response = await http.get('https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=MSFT&apikey=demo');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Quote.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

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
  String open;
  String high;
  String low;
  String price;
  String volume;
  String latestTradingDay;
  String previousClose;
  String change;
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
    open = json['02. open'];
    high = json['03. high'];
    low = json['04. low'];
    price = json['05. price'];
    volume = json['06. volume'];
    latestTradingDay = json['07. latest trading day'];
    previousClose = json['08. previous close'];
    change = json['09. change'];
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

/* ---------------------------------------------------------------------------------------------------------------------------------------
*  -------------------------------------------------------------- History ----------------------------------------------------------------
*  ---------------------------------------------------------------------------------------------------------------------------------------
* */

Future<PriceHistoryDaily> fetchPriceHistoryDaily() async {
  final response = await http.get('https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&apikey=demo');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return PriceHistoryDaily.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

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

/* ---------------------------------------------------------------------------------------------------------------------------------------
*  ------------------------------------------------------------ Donut Chart --------------------------------------------------------------
*  ---------------------------------------------------------------------------------------------------------------------------------------
* */

class DonutChart extends StatelessWidget {
  final List<DonutChartItem> seriesList;
  final String chartName;
  final bool animate;

  DonutChart(this.chartName, this.seriesList, {this.animate});

  factory DonutChart.withSampleData() {
    return new DonutChart(
      'Sample',
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
        [
          new charts.Series<DonutChartItem, int>(
            id: chartName,
            domainFn: (DonutChartItem item, _) => seriesList.indexOf(item),
            measureFn: (DonutChartItem item, _) => item.value,
            data: seriesList,
            labelAccessorFn: (DonutChartItem row, _) => '${row.name}',
          )
        ],
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 90,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(),
          ],
        )
    );
  }

  static List<DonutChartItem> _createSampleData() {
    var rnd = new Random();
    return [
      new DonutChartItem('ABEV3', rnd.nextInt(100)),
      new DonutChartItem('MGLU3', rnd.nextInt(100)),
      new DonutChartItem('ITUB4', rnd.nextInt(100)),
      new DonutChartItem('RADL3', rnd.nextInt(100)),
    ];
  }
}

class DonutChartItem {
  final String name;
  final int value;

  DonutChartItem(this.name, this.value);
}

/* ---------------------------------------------------------------------------------------------------------------------------------------
*  ------------------------------------------------------------- Line Chart --------------------------------------------------------------
*  ---------------------------------------------------------------------------------------------------------------------------------------
* */

class LineChart extends StatelessWidget {
  final String title;
  final List<LineChartItem> seriesList;
  final bool animate;

  LineChart(this.title, this.seriesList, {this.animate});

  factory LineChart.withSampleData() =>  new LineChart('Costs', _createSampleData(),animate: true);

  @override
  Widget build(BuildContext context) {

    final simpleCurrencyFormatter = new charts.BasicNumericTickFormatterSpec.fromNumberFormat(new NumberFormat.compactSimpleCurrency());

    return new charts.TimeSeriesChart(
        [
          new charts.Series<LineChartItem, DateTime>(
            id: title,
            domainFn: (LineChartItem row, _) => row.timeStamp,
            measureFn: (LineChartItem row, _) => row.cost,
            data: seriesList,
          )
        ],
        animate: animate,
        primaryMeasureAxis: new charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter, tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: false, desiredMinTickCount: 3, desiredMaxTickCount: 6)),
        domainAxis: new charts.DateTimeAxisSpec(tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(day: new charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM/yyyy')))
    );
  }

  static List<LineChartItem> _createSampleData() => [
    new LineChartItem(new DateTime(2017, 9, 25), 6),
    new LineChartItem(new DateTime(2017, 9, 26), 8),
    new LineChartItem(new DateTime(2017, 9, 27), 6),
    new LineChartItem(new DateTime(2017, 9, 28), 9),
    new LineChartItem(new DateTime(2017, 9, 29), 11),
    new LineChartItem(new DateTime(2017, 9, 30), 15),
    new LineChartItem(new DateTime(2017, 10, 01), 25),
    new LineChartItem(new DateTime(2017, 10, 02), 33),
    new LineChartItem(new DateTime(2017, 10, 03), 27),
    new LineChartItem(new DateTime(2017, 10, 04), 31),
    new LineChartItem(new DateTime(2017, 10, 05), 23),
  ];
}

class LineChartItem {
  final DateTime timeStamp;
  final double cost;

  LineChartItem(this.timeStamp, this.cost);
}