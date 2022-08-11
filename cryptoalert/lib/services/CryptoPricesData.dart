import 'dart:async';
import 'dart:convert' as convert;
import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:cryptoalert/global/global.dart' as globals;
import 'package:http/http.dart' as http;

Future<void> cryptodataupdate() async {
  List<dynamic> jsonResponse;
  try {
    print(globals.length.toString());
    Map<String, String> queryParams = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': globals.length.toString(),
      'page': '1',
      'sparkline': 'true'
    };
    var url =
        Uri.https('api.coingecko.com', '/api/v3/coins/markets', queryParams);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      print('In the func');
      jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      //print(jsonResponse[0]);
      //TopData = [];
      convert.jsonEncode(jsonResponse);
      if (jsonResponse.length < 20) {
        globals.hasNextPage = false;
      }
      for (int i = 0; i < TopData.length; i++) {
        //print(jsonResponse[i]['current_price'].toString());
        TopData[i].ID = jsonResponse[i]['id'].toString();
        TopData[i].Symbol = jsonResponse[i]['symbol'].toString();
        TopData[i].current_price = jsonResponse[i]['current_price'].toString();
        TopData[i].Daily_Change =
            jsonResponse[i]['price_change_percentage_24h'].toString();
        TopData[i].Cap_Daily_Change =
            jsonResponse[i]['market_cap_change_percentage_24h'].toString();
        TopData[i].Icon_Url = jsonResponse[i]['image'].toString();
        TopData[i].SparklineData =
            jsonResponse[i]['sparkline_in_7d']['price'] as List<dynamic>;

        //print(TopData[i].SparklineData[0]);
      }

      //globals.isFirstLoadRunning = false;
    } else {
      throw ('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print(e);
    //TopData = [];
  }
}
