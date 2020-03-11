import 'package:flutter/material.dart';
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/components/input_dialog.dart';
import 'package:portfolio_follow/database/dao/asset_dao.dart';
import 'package:portfolio_follow/models/asset.dart';

class AssetList extends StatefulWidget {
  @override
  _AssetListState createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  AssetDao _assetDao = AssetDao();

  Future<void> insertAsset(BuildContext context) async {
    List<InputDialogItem> asset = [
      InputDialogItem(label: 'Ativo', hint: 'ex. MGLU3', value: ''),
      InputDialogItem(label: 'Quantidade', hint: 'ex. 100', value: 0),
    ];

    List<InputDialogItem> result = await asyncInputDialog(context,
        title: 'Qual ativo deseja adicionar', items: asset);

    if(result == null) return;

    await _assetDao.insert(Asset(
      symbol: result.firstWhere((r) => r.label == 'Ativo').value.toString().trim(),
      quantity: int.parse(result.firstWhere((r) => r.label == 'Quantidade').value.toString().trim()),
    ));

    setState(() {});
  }

  Future<void> deleteAsset(int id) async {
    await _assetDao.delete(id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Asset>>(
          future: _assetDao.selectAllWithPrices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (_, int index) => ListTile(
                  title: Text(snapshot.data[index].symbol),
                  subtitle: Text(
                      'Qtd. ${snapshot.data[index]?.quantity.toString()} '
                          'R\$: ${snapshot.data[index]?.price.toString()} '
                          'Atualizado: ${GlobalVariables.dateFormat.format(snapshot.data[index]?.priceUpdated)}'),
                  onLongPress: () => {deleteAsset(snapshot.data[index].id)},
                ),
                itemCount: snapshot.data.length,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => insertAsset(context),
      ),
    );
  }
}
