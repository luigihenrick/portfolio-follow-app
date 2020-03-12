import 'package:flutter/material.dart';
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/database/dao/asset_dao.dart';
import 'package:portfolio_follow/models/asset.dart';

class RealtimeQuote extends StatelessWidget {
  final AssetDao _assetDao = AssetDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Asset>>(
        future: _assetDao.selectAllWithPrices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _createWidgets(snapshot),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  List<Widget> _createWidgets(AsyncSnapshot<List<Asset>> snapshot) {
    List<Widget> result = List();

    for (Asset asset in snapshot.data) {
      result.add(ListTile(
        title: Text(asset.symbol),
        subtitle: Text(
            'R\$ ${asset.price} - Atualizado em: ${GlobalVariables.dateTimeFormat.format(asset.priceUpdated)}'),
      ));
    }

    return result;
  }
}
