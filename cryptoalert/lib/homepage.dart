import 'package:cryptoalert/screens/Inforcard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> jsonResponse;
  var length = 0;
  int i = 0;
  Timer? timer;
  void cryptorequest() async {
    Map<String, String> queryParams = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '10',
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
      setState(() {
        length = jsonResponse.length;
        i++;
      });
      // print(jsonResponse);
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
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => cryptorequest());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
/* String k_m_b_generator(num) {
      if (num > 999 && num < 99999) {
        return "${(num / 1000).toStringAsFixed(1)} K";
      } else if (num > 99999 && num < 999999) {
        return "${(num / 1000).toStringAsFixed(0)} K";
      } else if (num > 999999 && num < 999999999) {
        return "${(num / 1000000).toStringAsFixed(1)} M";
      } else if (num > 999999999) {
        return "${(num / 1000000000).toStringAsFixed(1)} Bn";
      } else {
        return num.toString();
      }
    }*/

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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200,
                      width: 200,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: InkWell(
                          onTap: () {},
                          child: Card(
                              child: ListTile(
                                  title: Text(
                                      '${jsonResponse[index]['id']}  ${jsonResponse[index]['symbol']} '),
                                  subtitle: Text(
                                      '${jsonResponse[index]['market_cap']}')))),
                    );
                  },
                ),
              ),
            ),
            //Container(height: 100),
            SliverToBoxAdapter(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    double current_price = double.parse(jsonResponse[index]
                            ['current_price']
                        .toStringAsFixed(8));
                    return Container(
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 3.0,
                          margin: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ListTile(
                              title: Text(
                                  '${jsonResponse[index]['id']}  ${jsonResponse[index]['symbol']}'),
                              subtitle: Text(
                                  ' ${current_price}    ${jsonResponse[index]['price_change_percentage_24h']}%    ${jsonResponse[index]['market_cap']}')),
                        ),
                      ),
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }
}




/*Column(
          children: <Widget>[
            Expanded(
              
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    double current_price = double.parse(jsonResponse[index]
                            ['current_price']
                        .toStringAsFixed(8));
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                          /*${double.parse(jsonResponse[index]['high_24h']).round()}*/
                          'Hi           '),
                    );
                  }),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    double current_price = double.parse(jsonResponse[index]
                            ['current_price']
                        .toStringAsFixed(8));
                    return Card(
                      elevation: 3.0,
                      margin: const EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: ListTile(
                          title: Text(
                              '${jsonResponse[index]['id']}  ${jsonResponse[index]['symbol']}'),
                          subtitle: Text(
                              ' ${current_price}    ${jsonResponse[index]['price_change_percentage_24h']}%    ${jsonResponse[index]['market_cap']}')),
                    );
                  }),
            ),
          ],
        ), */