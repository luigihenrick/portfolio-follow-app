import 'package:flutter/material.dart';

Future<String> asyncInputDialog(BuildContext context, {title, String label, String hint, String confirmText}) async {
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