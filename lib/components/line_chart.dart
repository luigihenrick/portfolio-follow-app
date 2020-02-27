import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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