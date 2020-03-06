import 'package:flutter/material.dart';
import 'package:portfolio_follow/components/input_dialog.dart';
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
          asyncInputDialog(context,
              title: 'Qual ativo deseja buscar',
          ).then((stock) {
            setState(() => this._symbol = stock);
          })
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
