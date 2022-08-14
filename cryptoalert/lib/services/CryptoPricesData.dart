import 'dart:async';
import 'dart:convert' as convert;
import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:cryptoalert/global/global.dart' as globals;
import 'package:http/http.dart' as http;

List<String> markets = [];
Future<void> cryptodataupdate() async {
  List<dynamic> jsonResponse;
  var total_titles = TopData.length.toInt();
  int request_time =
      ((TopData.length.toDouble()/ 250.0).ceilToDouble()).toInt();
  int i = 0;
  var request_titles;
  for (int j = 1; j <= request_time; j++) {
    try {
      if (total_titles > 250) {
        request_titles = 250;
        total_titles = total_titles - 250;
      } else {
        request_titles = total_titles;
      }
      print('Request_titles = ${request_titles}');
      print('total_titles = ${total_titles}');
      print(globals.length.toString());
      Map<String, String> queryParams = {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': total_titles.toString(),
        'page': j.toString(),
        'sparkline': 'false'
      };
      var url =
          Uri.https('api.coingecko.com', '/api/v3/coins/markets', queryParams);
      var response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        print('In the func');
        jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        convert.jsonEncode(jsonResponse);
        if (jsonResponse.length < 20) {
          globals.hasNextPage = false;
        }
        for (int r = 0; i < request_titles; i++, r++) {
          TopData[i].ID = jsonResponse[r]['id'].toString();
          TopData[i].Symbol = jsonResponse[r]['symbol'].toString();
          TopData[i].current_price =
              jsonResponse[r]['current_price'].toString();
          TopData[i].Daily_Change =
              jsonResponse[r]['price_change_percentage_24h'].toString();
          TopData[i].Cap_Daily_Change =
              jsonResponse[r]['market_cap_change_percentage_24h'].toString();
          TopData[i].Icon_Url = jsonResponse[i]['image'].toString();
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
}
