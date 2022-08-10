import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:flutter/foundation.dart';

class CryptoData {
  late String ID;
  late String Symbol;
  late String current_price;
  late String Market_Cap;
  late String Daily_Change;
  late String Cap_Daily_Change;
  late String Icon_Url;

  CryptoData(
      {required this.ID,
      required this.Symbol,
      required this.current_price,
      required this.Daily_Change,
      required this.Market_Cap,
      required this.Cap_Daily_Change,
      required this.Icon_Url});
}

List<CryptoData> TopData = [];
Future<void> cryptorequest() async {
  List<dynamic> jsonResponse;
  try {
    Map<String, String> queryParams = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '20',
      'page': '1',
      'spartline': 'false'
    };
    var url =
        Uri.https('api.coingecko.com', '/api/v3/coins/markets', queryParams);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      //print(jsonResponse[0]);
      TopData = [];
      convert.jsonEncode(jsonResponse);
      print(jsonResponse.length);
      for (int i = 0; i < jsonResponse.length; i++) {
        TopData.add(CryptoData(
            ID: jsonResponse[i]['id'].toString(),
            Symbol: jsonResponse[i]['symbol'].toString(),
            current_price: jsonResponse[i]['current_price'].toString(),
            Daily_Change:
                jsonResponse[i]['price_change_percentage_24h'].toString(),
            Market_Cap: jsonResponse[i]['market_cap'].toString(),
            Cap_Daily_Change:
                jsonResponse[i]['market_cap_change_percentage_24h'].toString(),
            Icon_Url: jsonResponse[i]['image'].toString()));
      }
    } else {
      throw ('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print(e);
    TopData = [];
  }
}
