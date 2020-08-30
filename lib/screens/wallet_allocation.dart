import 'package:flutter/material.dart';
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/components/donut_chart.dart';
import 'package:portfolio_follow/database/dao/asset_dao.dart';
import 'package:portfolio_follow/models/asset_customer.dart';

const _chartTitle = 'Wallet Allocation';

class WalletAllocation extends StatelessWidget {
  final bool animate;

  WalletAllocation({this.animate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<DonutChartItem>>(
        future: fetchWalletAllocationData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double totalAmount = 0.0;

            for (DonutChartItem item in snapshot.data) {
              totalAmount += item.value;
            }

            return Scaffold(
                body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Patrimônio: ${GlobalVariables.currencyFormat.format(totalAmount ?? 0)}',
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
                new Padding(
                  padding: new EdgeInsets.all(25.0),
                  child: new SizedBox(
                    height: 400.0,
                    child: DonutChart(
                      _chartTitle,
                      snapshot.data,
                      animate: animate,
                    ),
                  ),
                )
              ],
            ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<List<DonutChartItem>> fetchWalletAllocationData() async {
  AssetDao assetDao = AssetDao();
  List<DonutChartItem> result = List();

  for (AssetCustomer asset in await assetDao.selectAllWithPrices()) {
    result.add(DonutChartItem(
        asset.symbol, (asset.quantity * asset.price).toDouble()));
  }

  return result;
}
