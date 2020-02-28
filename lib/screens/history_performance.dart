import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/line_chart.dart';
import 'package:portfolio_follow/models/history_price.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _pageName = 'Histórico';
const _chartTitle = 'History Prices';
const _errorMessage = 'Falha ao carregar preço histórico';

class HistoryPerformance extends StatefulWidget {
  final bool animate;

  HistoryPerformance({this.animate});

  @override
  _HistoryPerformanceState createState() => _HistoryPerformanceState();
}

class _HistoryPerformanceState extends State<HistoryPerformance> {
  String symbol = 'MSFT';
  Future<PriceHistoryDaily> futurePriceHistoryDaily;

  @override
  void initState() {
    futurePriceHistoryDaily = fetchPriceHistoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageName)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<PriceHistoryDaily>(
            future: futurePriceHistoryDaily,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    new Text(
                      'Ativo: ${snapshot.data.metaData.symbol}',
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                    new Padding(
                      padding: new EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 16.0),
                      child: new SizedBox(
                        height: 400.0,
                        child: LineChart(
                          _chartTitle,
                          snapshot.data.dailyTimeSeries
                              .map((item) =>
                                  new LineChartItem(item.date, item.close))
                              .toList(),
                          animate: widget.animate,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<PriceHistoryDaily> fetchPriceHistoryData() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=demo');

    if (response.statusCode == 200) {
      return PriceHistoryDaily.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }
}
