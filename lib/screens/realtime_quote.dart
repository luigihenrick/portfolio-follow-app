import 'package:flutter/material.dart';
import 'package:portfolio_follow/models/quote.dart';
import 'package:portfolio_follow/services/alpha_vantage.dart';

class RealtimeQuote extends StatefulWidget {
  RealtimeQuote();

  @override
  _RealtimeQuoteState createState() => _RealtimeQuoteState();
}

class _RealtimeQuoteState extends State<RealtimeQuote> {
  String _symbol = 'MSFT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Quote>(
              future: AlphaVantageService.fetchQuoteData(_symbol),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${snapshot.data.globalQuote.symbol} - ${snapshot.data.globalQuote.price}',
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                        )
                      ]);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _asyncInputDialog(context).then((stock) {
            setState(() => this._symbol = stock);
          })
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String symbol = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qual ativo deseja buscar'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Ativo', hintText: 'ex. MGLU3.SAO'),
                onChanged: (value) {
                  symbol = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(symbol);
              },
            ),
          ],
        );
      },
    );
  }
}
