import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/line_chart.dart';
import 'package:portfolio_follow/models/history_price.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _chartTitle = 'History Prices';
const _errorMessage = 'Falha ao carregar preço histórico';

class HistoryPerformance extends StatelessWidget {
  final bool animate;

  final Future<PriceHistoryDaily> futurePriceHistoryDaily;

  HistoryPerformance(this.futurePriceHistoryDaily, {this.animate});

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
                padding:
                    new EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: new SizedBox(
                  height: 400.0,
                  child: LineChart(
                    _chartTitle,
                    snapshot.data.dailyTimeSeries
                        .map((item) => new LineChartItem(item.date, item.close))
                        .toList(),
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

  static Future<PriceHistoryDaily> fetchPriceHistoryData() async {
    final response = await http.get('https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&apikey=demo');

    if (response.statusCode == 200) {
      return PriceHistoryDaily.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }
}
