import 'package:flutter/material.dart';

class QuotePage extends StatelessWidget{
  final Future<Quote> futureQuote;

  QuotePage(this.futureQuote);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: futureQuote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text('${snapshot.data.globalQuote.symbol} - ${snapshot.data.globalQuote.price}', style: TextStyle(fontSize: 25, color: Colors.grey))
          ]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}