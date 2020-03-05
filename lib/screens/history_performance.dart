import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/line_chart.dart';
import 'package:portfolio_follow/models/history_price.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio_follow/services/alpha_vantage.dart';

const _chartTitle = 'History Prices';

class HistoryPerformance extends StatefulWidget {
  final bool animate;

  HistoryPerformance({this.animate});

  @override
  _HistoryPerformanceState createState() => _HistoryPerformanceState();
}

class _HistoryPerformanceState extends State<HistoryPerformance> {
  String _symbol = 'MSFT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<PriceHistoryDaily>(
              future: AlphaVantageService.fetchPriceHistoryData(_symbol),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _asyncInputDialog(context).then((stock) {
            setState(() => this._symbol = stock);
          })
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String symbol = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qual ativo deseja buscar'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'Ativo', hintText: 'ex. MGLU3.SAO'),
                onChanged: (value) {
                  symbol = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(symbol);
              },
            ),
          ],
        );
      },
    );
  }
}
