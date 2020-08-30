import 'package:flutter/material.dart';
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/components/input_dialog.dart';
import 'package:portfolio_follow/database/dao/asset_dao.dart';
import 'package:portfolio_follow/models/asset_customer.dart';

class AssetList extends StatefulWidget {
  @override
  _AssetListState createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  AssetDao _assetDao = AssetDao();

  Future<void> insertAsset(BuildContext context) async {
    List<InputDialogItem> asset = [
      //InputDialogItem(label: 'Tipo', hint: 'ex. Renda Variável', value: 'RV'),
      InputDialogItem(label: 'Ativo', hint: 'ex. MGLU3', value: ''),
      InputDialogItem(label: 'Quantidade', hint: 'ex. 100', value: 0)
    ];

    List<InputDialogItem> result = await asyncInputDialog(context,
        title: 'Qual ativo deseja adicionar', items: asset);

    if (result == null) return;

    await _assetDao.insert(AssetCustomer(
      symbol: result.firstWhere((r) => r.label == 'Ativo').value.toString().trim(),
      quantity: result.firstWhere((r) => r.label == 'Quantidade').value,
      operationDate: result.firstWhere((r) => r.label == 'Data Operação')?.value ?? DateTime.now(),
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
        child: FutureBuilder<List<AssetCustomer>>(
          future: _assetDao.selectAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (_, int index) => ListTile(
                  title: Text(snapshot.data[index].symbol),
                  subtitle: Text(
                      'Quantidade: ${snapshot.data[index]?.quantity.toString()} '
                      'Data: ${snapshot.data[index]?.operationDate != null ? GlobalVariables.dateFormat.format(snapshot.data[index]?.operationDate) : "Não informado"}'),
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
