import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/donut_chart.dart';

const _chartTitle = 'Wallet Allocation';

class WalletAllocation extends StatefulWidget {
  final bool animate;

  WalletAllocation({this.animate});

  @override
  _WalletAllocationState createState() => _WalletAllocationState();
}

class _WalletAllocationState extends State<WalletAllocation> {
  List<DonutChartItem> chartData = fetchWalletAllocationData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Patrimônio: ${chartData.map((i) => i.value).reduce((acc, item) => acc + item)} K',
            style: TextStyle(fontSize: 25, color: Colors.grey),
          ),
          new Padding(
            padding: new EdgeInsets.all(25.0),
            child: new SizedBox(
              height: 400.0,
              child: DonutChart(
                _chartTitle,
                chartData,
                animate: widget.animate,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            chartData = fetchWalletAllocationData();
          })
        },
        child: Icon(Icons.refresh),
      ),
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
