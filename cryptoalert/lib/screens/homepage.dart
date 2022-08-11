import 'package:cryptoalert/screens/CryptoConversion.dart';
import 'package:cryptoalert/screens/details.dart';
import 'package:cryptoalert/services/CryptoPricesData.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:cryptoalert/global/global.dart' as globals;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

@override
void ValSymbol(double market_cap, String Sym) {
  if (market_cap >= 1000000000) {
    market_cap = market_cap / 1000000000;
    Sym = 'Bn';
  } else if (market_cap < 1000000000 && market_cap > 100000000) {
    market_cap = market_cap / 100000000;
    Sym = 'Bn';
  } else if (market_cap > 1000000 && market_cap < 100000000) {
    market_cap = market_cap / 1000000;
    Sym = 'M';
  }
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  final controller = ScrollController();

  Future<void> cryptorequest() async {
    List<dynamic> jsonResponse;
    try {
      Map<String, String> queryParams = {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': '20',
        'page': globals.page.toString(),
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

            //print(TopData[i].SparklineData[0]);
          }
          globals.length = TopData.length;
          globals.page++;
        });

        //globals.isFirstLoadRunning = false;
      } else {
        throw ('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
      //TopData = [];
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
     await cryptodataupdate();
      setState(() {
       globals.length = TopData.length;
     });
    });

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        print('Booyah');
        cryptorequest();
      }
    });

    //});
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/gradient.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomScrollView(
            controller:
                controller, //The parent controller always controlls the listview, not the child. it wont work on any nested listview
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: 120,
                centerTitle: true,
                collapsedHeight: 110,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/gradient.jpg"),
                        fit: BoxFit.cover),
                  ),
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      bool isPressed = false;
                      Color CardColor = Colors.grey;
                      IconData CardIcon = Icons.arrow_drop_down_rounded;
                      String Sym = ' ';

                      double market_cap =
                          double.parse(TopData[index].Market_Cap);
                      if (market_cap >= 1000000000) {
                        market_cap = market_cap / 1000000000;

                        Sym = 'Bn';
                      } else if (market_cap < 1000000000 &&
                          market_cap > 100000000) {
                        market_cap = market_cap / 100000000;

                        Sym = 'Bn';
                      } else if (market_cap > 1000000 &&
                          market_cap < 100000000) {
                        market_cap = market_cap / 1000000;

                        Sym = 'M';
                      }

                      if (double.parse(TopData[index].Cap_Daily_Change) < 0) {
                        CardColor = Colors.redAccent;
                        CardIcon = Icons.arrow_drop_down_rounded;
                      } else if (double.parse(TopData[index].Cap_Daily_Change) >
                          0) {
                        CardColor = Colors.greenAccent;
                        CardIcon = Icons.arrow_drop_up_rounded;
                      } else {
                        CardColor = Colors.grey;
                        CardIcon = Icons.arrow_drop_up_rounded;
                      }
                      return Container(
                        height: 200,
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                isPressed = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isPressed = false;
                              });
                            },
                            //onTap: () {},
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white60, Colors.white10]),
                                  color: Colors.white
                                      .withOpacity(isPressed ? 0.5 : 0.3),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      width: 0.5, color: Colors.white30),
                                ),
                                child: ListTile(
                                    title: Row(children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 8,
                                        backgroundImage: NetworkImage(
                                            TopData[index].Icon_Url),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${TopData[index].Symbol.toUpperCase()}  ',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        CardIcon,
                                        color: CardColor,
                                      ),
                                    ]),
                                    subtitle: Text(
                                      '\$${market_cap.toStringAsFixed(2)} ${Sym}  ${double.parse(TopData[index].Cap_Daily_Change).toStringAsFixed(3)}%',
                                      style: TextStyle(
                                          color: CardColor,
                                          fontWeight: FontWeight.w600),
                                    )))),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: ListView.builder(
                      //controller: controller,
                      //prevents last element from being out of bounds
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: globals.length + 1,
                      itemBuilder: (context, index) {
                        if (index < globals.length) {
                          bool isPressed = false;
                          //print(IsHover);
                          // print(TopData[index].current_price);
                          Color CardColor = Colors.grey;
                          IconData CardIcon = Icons.arrow_drop_down_rounded;
                          if (double.parse(TopData[index].Daily_Change) < 0) {
                            CardColor = Colors.redAccent;
                            CardIcon = Icons.arrow_drop_down_rounded;
                          } else if (double.parse(TopData[index].Daily_Change) >
                              0) {
                            CardColor = Colors.greenAccent;
                            CardIcon = Icons.arrow_drop_up_rounded;
                          } else {
                            CardColor = Colors.grey;
                            CardIcon = Icons.arrow_drop_up_rounded;
                          }

                          String Sym = ' ';
                          double market_cap =
                              double.parse(TopData[index].Market_Cap);
                          if (market_cap >= 1000000000) {
                            market_cap = market_cap / 1000000000;

                            Sym = 'Bn';
                          } else if (market_cap < 1000000000 &&
                              market_cap > 100000000) {
                            market_cap = market_cap / 100000000;

                            Sym = 'Bn';
                          } else if (market_cap > 1000000 &&
                              market_cap < 100000000) {
                            market_cap = market_cap / 1000000;

                            Sym = 'M';
                          }
                          //CardColor = Colors.greenAccent;

                          return GestureDetector(
                            onTapDown: (_) {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CurrencyDetails(),
                                      settings: RouteSettings(arguments: {
                                        'currency_ID': TopData[index].ID,
                                        'currency_Symbol':
                                            TopData[index].Symbol.toUpperCase(),
                                      })));
                            },
                            onTapUp: (_) {
                              setState(() {
                                isPressed = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white60, Colors.white10]),
                                color: Colors.white
                                    .withOpacity(isPressed ? 0.5 : 0.3),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 0.5, color: Colors.white30),
                              ),
                              child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 8,
                                        backgroundImage: NetworkImage(
                                            TopData[index].Icon_Url),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('${TopData[index].ID.capitalize()}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          '${TopData[index].Symbol.toString().toUpperCase()}',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(CardIcon, color: CardColor),
                                      Text(
                                        '\$${TopData[index].current_price}    ${double.parse(TopData[index].Daily_Change).toStringAsFixed(3)}%   \$${market_cap.toStringAsFixed(3)} ${Sym}',
                                        style: TextStyle(
                                            color: CardColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        height: 15,
                                        width: 45,
                                        child: Sparkline(
                                            data: TopData[index]
                                                .SparklineData
                                                .map((e) => double.parse(e
                                                    .toString())) //takes each element of the list and converts them to a double list.
                                                .toList(),
                                            lineColor: CardColor),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
