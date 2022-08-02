import 'package:cryptoalert/screens/Inforcard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:cryptoalert/models/TopCrypto.dart';

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
  var length = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      cryptorequest();
      setState(() {
        length = TopData.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //List<Color> AllColors = [Colors.redAccent, Colors.greenAccent, Colors.grey];
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 120,
              centerTitle: true,
              collapsedHeight:
                  110, //when user scrolls, how much the appbar should collpase
              flexibleSpace: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    Color CardColor = Colors.grey;
                    IconData CardIcon = Icons.arrow_drop_down_rounded;
                    String Sym = ' ';

                    double market_cap = double.parse(TopData[index].Market_Cap);
                    if (market_cap >= 1000000000) {
                      market_cap = market_cap / 1000000000;

                      Sym = 'Bn';
                    } else if (market_cap < 1000000000 &&
                        market_cap > 100000000) {
                      market_cap = market_cap / 100000000;

                      Sym = 'Bn';
                    } else if (market_cap > 1000000 && market_cap < 100000000) {
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
                      child: InkWell(
                          onTap: () {},
                          child: Card(
                              child: ListTile(
                                  title: Row(children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 8,
                                      backgroundImage:
                                          NetworkImage(TopData[index].Icon_Url),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        '${TopData[index].Symbol.toUpperCase()}  '),
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
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    print(TopData[index].current_price);
                    Color CardColor = Colors.grey;
                    IconData CardIcon = Icons.arrow_drop_down_rounded;
                    if (double.parse(TopData[index].Daily_Change) < 0) {
                      CardColor = Colors.redAccent;
                      CardIcon = Icons.arrow_drop_down_rounded;
                    } else if (double.parse(TopData[index].Daily_Change) > 0) {
                      CardColor = Colors.greenAccent;
                      CardIcon = Icons.arrow_drop_up_rounded;
                    } else {
                      CardColor = Colors.grey;
                      CardIcon = Icons.arrow_drop_up_rounded;
                    }

                    String Sym = ' ';

                    double market_cap = double.parse(TopData[index].Market_Cap);
                    if (market_cap >= 1000000000) {
                      market_cap = market_cap / 1000000000;

                      Sym = 'Bn';
                    } else if (market_cap < 1000000000 &&
                        market_cap > 100000000) {
                      market_cap = market_cap / 100000000;

                      Sym = 'Bn';
                    } else if (market_cap > 1000000 && market_cap < 100000000) {
                      market_cap = market_cap / 1000000;

                      Sym = 'M';
                    }
                    //CardColor = Colors.greenAccent;
                    return InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 3.0,
                        margin: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 8,
                                  backgroundImage:
                                      NetworkImage(TopData[index].Icon_Url),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('${TopData[index].ID.capitalize()}'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '${TopData[index].Symbol.toString().toUpperCase()}')
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(CardIcon, color: CardColor),
                                Text(
                                  '\$${TopData[index].current_price}    ${double.parse(TopData[index].Daily_Change).toStringAsFixed(3)}%   \$${market_cap.toStringAsFixed(3)} ${Sym}',
                                  style: TextStyle(
                                      color: CardColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
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
