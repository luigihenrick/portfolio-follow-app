import 'package:flutter/material.dart';

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