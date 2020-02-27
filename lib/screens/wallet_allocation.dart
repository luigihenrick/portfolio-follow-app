import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/donut_chart.dart';

const _chartTitle = 'Wallet Allocation';

class WalletAllocation extends StatelessWidget {
  final List<DonutChartItem> chartData;
  final bool animate;

  WalletAllocation(this.chartData, {this.animate});

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
              _chartTitle,
              chartData,
              animate: animate,
            ),
          ),
        )
      ],
    );
  }

  static List<DonutChartItem> fetchWalletAllocationData() {
    var rnd = new Random();
    return [
      new DonutChartItem('ABEV3', rnd.nextInt(100)),
      new DonutChartItem('MGLU3', rnd.nextInt(100)),
      new DonutChartItem('ITUB4', rnd.nextInt(100)),
      new DonutChartItem('RADL3', rnd.nextInt(100)),
    ];
  }
}