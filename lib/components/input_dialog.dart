import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<List<InputDialogItem>> asyncInputDialog(BuildContext context,
    {@required String title, List<InputDialogItem> items}) async {
  return showDialog<List<InputDialogItem>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          children: buildFields(items),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(items);
            },
          )
        ],
      );
    },
  );
}

class InputDialogItem {
  String label;
  String hint;
  dynamic value;

  InputDialogItem({this.label, this.hint, this.value});
}

List<Widget> buildFields(List<InputDialogItem> items) {
  List<Widget> result = List();

  for (InputDialogItem item in items) {
    result.add(
      Row(
        children: <Widget>[
          item.value is EnumProperty
              ? Text('item: ${item.value}')
              : Expanded(
                  child: new TextField(
                    autofocus: true,
                    keyboardType: _getKeyboardType(item),
                    decoration: new InputDecoration(
                      labelText: item.label ?? '',
                      hintText: item.hint ?? '',
                    ),
                    onChanged: (value) {
                      if (item.value is int) {
                        item.value = int.parse(value);
                      } else if (item.value is DateTime) {
                        item.value = DateTime.parse(value);
                      } else {
                        item.value = value;
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  return result;
}

TextInputType _getKeyboardType(InputDialogItem item) {
  if (item.value is int) {
    return TextInputType.number;
  } else if (item.value is DateTime) {
    return TextInputType.datetime;
  } else {
    return TextInputType.text;
  }
}
