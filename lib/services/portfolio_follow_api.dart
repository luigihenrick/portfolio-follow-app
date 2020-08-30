import 'dart:convert';
import 'package:http/http.dart' as http;
import 'file:///C:/repos/portfolio-follow-app/lib/models/asset.dart';

class PortfolioFollowService {
  static final String _errorMessage = 'Falha ao buscar informações do(s) ativo(s)';

  static Future<Asset> fetchPriceHistoryData(String symbol) async {
    final response = await http.get(
        'https://portfolio-follow-api.herokuapp.com/api/renda-variavel/historico/$symbol');

    if (response.statusCode == 200) {
      return Asset.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }

  static Future<Asset> fetchQuoteData(String symbol) async {
    final response = await http.get(
        'https://portfolio-follow-api.herokuapp.com/api/renda-variavel/preco/$symbol');

    if (response.statusCode == 200) {
      return Asset.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage);
    }
  }
}