import 'package:flutter/material.dart';

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