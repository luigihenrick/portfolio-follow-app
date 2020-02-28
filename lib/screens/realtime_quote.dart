import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:portfolio_follow/models/quote.dart';

const _pageName = 'Cotação';
const _errorMessage = 'Falha ao buscar cotação.';

class RealtimeQuote extends StatefulWidget {
  RealtimeQuote();

  @override
  _RealtimeQuoteState createState() => _RealtimeQuoteState();
}

class _RealtimeQuoteState extends State<RealtimeQuote> {
  String _symbol = 'MSFT';
  Future<Quote> _futureQuote;

  @override
  void initState() {
    _futureQuote = _fetchQuoteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageName)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<Quote>(
            future: _futureQuote,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _asyncInputDialog(context).then((stock) {
            this._symbol = stock;
            setState(() => {_futureQuote = _fetchQuoteData()});
          })
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<Quote> _fetchQuoteData() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$_symbol&apikey=demo');

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qual ativo deseja buscar'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Ativo', hintText: 'ex. MGLU.SAO'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}
