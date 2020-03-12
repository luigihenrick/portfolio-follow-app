import 'package:intl/intl.dart';

class GlobalVariables {
  static const String alphaVantageKey = 'YOUR_KEY';
  static const bool animate = true;
  static NumberFormat currencyFormat =
      new NumberFormat.currency(locale: 'pt', symbol: 'R\$');
  static DateFormat dateFormat = new DateFormat('dd/MM/yyyy');
  static DateFormat dateTimeFormat = new DateFormat('dd/MM/yyyy HH:mm');
}
