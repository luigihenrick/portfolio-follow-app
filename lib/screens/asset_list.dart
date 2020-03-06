import 'package:flutter/material.dart';
import 'package:portfolio_follow/database/app_database.dart';
import 'package:portfolio_follow/models/asset.dart';
import 'package:portfolio_follow/models/exchange.dart';

class AssetList extends StatefulWidget {
  @override
  _AssetListState createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  
  Future<void> insertAsset() async {
    await insert(Asset(
      symbol: 'ITUB4',
      quantity: 40,
      exchange: Exchange.bovespa,
    ));

    setState(() {});
  }

  Future<void> deleteAsset(int id) async {
    await delete(id);

    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Asset>>(
          future: selectAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (_, int index) => ListTile(
                  title: Text(snapshot.data[index].symbol),
                  subtitle: Text(snapshot.data[index].quantity.toString()),
                  onLongPress: () => {
                    deleteAsset(snapshot.data[index].id)
                  },
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
        onPressed: () => insertAsset(),
      ),
    );
  }
}
