import 'package:cryptoalert/screens/Inforcard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> jsonResponse;
  void cryptorequest() async {
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
      convert.jsonEncode(jsonResponse);
      // as Map<String, String>;

      /*jsonResponse.forEach((element) {
                        convert.jsonEncode(element);

                        print(element['id']);
                      });*/
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    cryptorequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber,
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: jsonResponse.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                child: Text(
                    /*${double.parse(jsonResponse[index]['high_24h']).round()}*/
                    '${jsonResponse[index]['id']}         ${jsonResponse[index]['current_price']} '),
              );
            }),
      ),
    );
  }
}
