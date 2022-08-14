import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:cryptoalert/global/global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:cryptoalert/services/CryptoPricesData.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({Key? key}) : super(key: key);

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> {
  Future<void> cryptorequest() async {
    List<dynamic> jsonResponse;

    try {
      Map<String, String> queryParams = {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': '20',
        'page': '1',
        'sparkline': 'true'
      };
      var url =
          Uri.https('api.coingecko.com', '/api/v3/coins/markets', queryParams);
      var response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        //print(jsonResponse[0]);
        //TopData = [];
        convert.jsonEncode(jsonResponse);
        if (jsonResponse.length < 20) {
          globals.hasNextPage = false;
        }
        setState(() {
          for (int i = 0; i < jsonResponse.length; i++) {
            TopData.add(CryptoData(
                ID: jsonResponse[i]['id'].toString(),
                Symbol: jsonResponse[i]['symbol'].toString(),
                current_price: jsonResponse[i]['current_price'].toString(),
                Daily_Change:
                    jsonResponse[i]['price_change_percentage_24h'].toString(),
                Market_Cap: jsonResponse[i]['market_cap'].toString(),
                Cap_Daily_Change: jsonResponse[i]
                        ['market_cap_change_percentage_24h']
                    .toString(),
                Icon_Url: jsonResponse[i]['image'].toString(),
                SparklineData: jsonResponse[i]['sparkline_in_7d']['price']
                    as List<dynamic>));
            globals.length = TopData.length;
            globals.page++;
            //print(TopData[i].SparklineData[0]);
          }
        });
        //globals.isFirstLoadRunning = false;
      } else {
        throw ('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }

  void WaitForData() async {
    await cryptorequest();
    if (TopData.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/initial');
    } else {
      Navigator.pushReplacementNamed(context, '/errpage');
    }
  }

  @override
  void initState() {
    super.initState();
    WaitForData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 50.0,
        )));
  }
}
