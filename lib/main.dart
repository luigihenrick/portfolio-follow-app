import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      title: 'Portfolio',
      home: PageState(title: 'Minha Carteira', animate: true),
    )
);

class PageState extends StatefulWidget{
  final String title;
  final bool animate;

  PageState({Key key, this.title, this.animate}) : super(key: key);

  @override
  _PageState createState() => _PageState();

}

class _PageState extends State<PageState>{
  static List<ChartItem> seriesList = DonutAutoLabelChart._createSampleData();
  static int totalAmount = seriesList.map((i) => i.value).reduce((acc, item) => acc + item);
  
  void randomizeData(){
    setState(() {
      seriesList = DonutAutoLabelChart._createSampleData();
      totalAmount = seriesList.map((i) => i.value).reduce((acc, item) => acc + item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Patrimônio: $totalAmount K',
            style: TextStyle(fontSize: 25, color: Colors.grey),
          ),
          new Padding(
            padding: new EdgeInsets.all(32.0),
            child: new SizedBox(
              height: 400.0,
              child: DonutAutoLabelChart('Stocks Allocation', seriesList, animate: widget.animate,),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: randomizeData,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
    );
  }

}

class DonutAutoLabelChart extends StatelessWidget {
  final List<ChartItem> seriesList;
  final String chartName;
  final bool animate;

  DonutAutoLabelChart(this.chartName, this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withSampleData() {
    return new DonutAutoLabelChart(
      'Sample',
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
        [
          new charts.Series<ChartItem, int>(
            id: chartName,
            domainFn: (ChartItem item, _) => seriesList.indexOf(item),
            measureFn: (ChartItem item, _) => item.value,
            data: seriesList,
            // Set a label accessor to control the text of the arc label.
            labelAccessorFn: (ChartItem row, _) => '${row.name}',
          )
        ],
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 90,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(),
          ],
        ));
  }

  static List<ChartItem> _createSampleData() {
    var rnd = new Random();
    return [
      new ChartItem('ABEV3', rnd.nextInt(100)),
      new ChartItem('MGLU3', rnd.nextInt(100)),
      new ChartItem('ITUB4', rnd.nextInt(100)),
      new ChartItem('RADL3', rnd.nextInt(100)),
    ];
  }
}

class ChartItem {
  final String name;
  final int value;

  ChartItem(this.name, this.value);
}
