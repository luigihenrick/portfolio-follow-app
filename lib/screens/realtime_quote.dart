import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:portfolio_follow/models/quote.dart';

const _errorMessage = 'Falha ao buscar cotação.';

class RealtimeQuote extends StatelessWidget {
  final Future<Quote> futureQuote;

  RealtimeQuote(this.futureQuote);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: futureQuote,
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
    );
  }

  static Future<Quote> fetchQuoteData() async {
    final response = await http.get('https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=MSFT&apikey=demo');

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }
}
