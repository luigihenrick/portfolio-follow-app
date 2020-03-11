import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/models/history_price.dart';
import 'package:portfolio_follow/models/quote.dart';

class AlphaVantageService {
  static final String _errorMessage = 'Falha ao buscar informações do(s) ativo(s)';

  static Future<PriceHistoryDaily> fetchPriceHistoryData(String symbol) async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol.SAO&apikey=${GlobalVariables.alphaVantageKey}');

    if (response.statusCode == 200) {
      return PriceHistoryDaily.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }

  static Future<Quote> fetchQuoteData(String symbol) async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol.SAO&apikey=${GlobalVariables.alphaVantageKey}');

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }
}