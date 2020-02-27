import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DonutChart extends StatelessWidget {
  final List<DonutChartItem> seriesList;
  final String chartName;
  final bool animate;

  DonutChart(this.chartName, this.seriesList, {this.animate});

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
}

class DonutChartItem {
  final String name;
  final int value;

  DonutChartItem(this.name, this.value);
}
