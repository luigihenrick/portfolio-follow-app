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
  String _symbol = 'MSFT';
  Future<PriceHistoryDaily> _futurePriceHistoryDaily;

  @override
  void initState() {
    _futurePriceHistoryDaily = _fetchPriceHistoryData();
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
            future: _futurePriceHistoryDaily,
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
        onPressed: () => {
          _asyncInputDialog(context).then((stock) {
            this._symbol = stock;
            setState(
              () => {_futurePriceHistoryDaily = _fetchPriceHistoryData()},
            );
          })
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<PriceHistoryDaily> _fetchPriceHistoryData() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$_symbol&apikey=demo');

    if (response.statusCode == 200) {
      return PriceHistoryDaily.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qual ativo deseja buscar'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Ativo', hintText: 'ex. MGLU3.SAO'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}
