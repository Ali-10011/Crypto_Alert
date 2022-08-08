import 'package:cryptoalert/screens/details.dart';
import 'package:flutter/material.dart';
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
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
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
                    image: const DecorationImage(
                        image: AssetImage("assets/gradient.jpg"),
                        fit: BoxFit.cover),
                  ),
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: length,
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
                      physics: const ClampingScrollPhysics(), //prevents last element from being out of bounds
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: length,
                      itemBuilder: (context, index) {
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
                             Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => const CurrencyDetails(),
                                settings: RouteSettings(arguments: {
                                  'currency_ID': TopData[index].ID,
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
                              border:
                                  Border.all(width: 0.5, color: Colors.white30),
                            ),
                            child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 8,
                                      backgroundImage:
                                          NetworkImage(TopData[index].Icon_Url),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text('${TopData[index].ID.capitalize()}',
                                        style: TextStyle(color: Colors.white)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        '${TopData[index].Symbol.toString().toUpperCase()}',
                                        style: TextStyle(color: Colors.white))
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
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
