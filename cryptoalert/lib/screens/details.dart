import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:cryptoalert/models/ChartData.dart';

class CurrencyDetails extends StatefulWidget {
  const CurrencyDetails({Key? key})
      : super(key: key); //Graph integrated but Axis and interval logic left

  @override
  State<CurrencyDetails> createState() => _CurrencyDetailsState();
}

class _CurrencyDetailsState extends State<CurrencyDetails> {
  List<FlSpot> priceData = [];
  double minPrice = 0;
  double maxPrice = 0;
  double medianPrice = 0;
  late double interval = 1;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //This function helps completing the initstate first, which causes error sometimes
      await _cryptochartDatarequest();
      setState(() {
        //just to make the graph load
      });
    });
  }

  @override
  Future<void> _cryptochartDatarequest() async {
    Map<dynamic, dynamic> jsonResponse;
    Map<dynamic, dynamic> route_Data =
        ModalRoute.of(context)!.settings.arguments as Map;
    String coin_ID = route_Data['currency_ID'];
    //print(data['Total'].toString());
    List<double> TempPrice = [];
    try {
      Map<String, String> queryParams = {
        'vs_currency': 'usd',
        'days': '1',
        'interval': 'hourly'
      };
      var url = Uri.https('api.coingecko.com',
          '/api/v3/coins/$coin_ID/market_chart', queryParams);
      var response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        jsonResponse =
            convert.jsonDecode(response.body) as Map<dynamic, dynamic>;
        //print(jsonResponse[0]);
        LChartData = [];
        // print(jsonResponse['prices'][24][0]);
        // print(jsonResponse['prices']);

        for (int i = 0; i < jsonResponse['prices'].length; i++) {
          //I can clear all this clutter in one loop, but this data may be reusable in the future so holding in for that
          LChartData.add(ChartData(
              timeStamp: jsonResponse['prices'][i][0].toString(),
              price: jsonResponse['prices'][i][1].toString(),
              volume: jsonResponse['total_volumes'][i][1].toString(),
              marketCap: jsonResponse['market_caps'][i][1].toString()));
        }

        priceData = [];

        for (int i = 0; i < LChartData.length; i++) {
          double temp = double.parse(LChartData[i].price);

          String temp2 = temp.toStringAsFixed(3);
          TempPrice.add(double.parse(temp2));
          priceData.add(FlSpot(i.toDouble(), double.parse(temp2)));
        }

        TempPrice.sort();

        int MidIndex = ((LChartData.length + 1) / 2).toInt();
        minPrice = TempPrice.first; //case statement only accepts INT
        maxPrice = TempPrice.last;
        medianPrice = TempPrice[MidIndex];
        if (maxPrice >= 1000) {
          interval = 1;
        } else if (maxPrice >= 100) {
          interval = 0.1;
        } else if (maxPrice >= 2) {
          interval = 0.01;
        } else {
          interval = 0.001;
        }
        print(TempPrice.first);
        print(TempPrice[MidIndex]);
        print(TempPrice.last);
        print(minPrice);
        print(maxPrice);
      }
    } catch (e) {
      print(e);
    }
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    late String text;
    print(value);
    if (maxPrice >= 10000) {
      if (value.toInt() == minPrice.toInt()) {
        text = (minPrice / 1000).toStringAsFixed(1).toString() + 'K';
      } else if (value.toInt() == medianPrice.toInt()) {
        text = (medianPrice / 1000).toStringAsFixed(1).toString() + 'K';
      } else if (value.toInt() == maxPrice.toInt()) {
        text = (maxPrice / 1000).toStringAsFixed(1).toString() + 'K';
      } else {
        return Container();
      }
    } else if (maxPrice >= 1000) {
      if (value.toInt() == minPrice.toInt()) {
        text = (minPrice / 1000).toStringAsFixed(2).toString() + 'K';
        //minPrice = -1;
        print('Min');
        print(value);
      } else if (value.toInt() == medianPrice.toInt()) {
        text = (medianPrice / 1000).toStringAsFixed(2).toString() + 'K';

        print('Median');
        print(value);
      } else if (value.toInt() == maxPrice.toInt()) {
        text = (maxPrice / 1000).toStringAsFixed(2).toString() + 'K';
        //maxPrice = -1;
        print('Max');
        print(value);
      } else {
        return Container();
      }
    } else if (maxPrice >= 100 && maxPrice < 1000) {
      if (value.toStringAsFixed(2) == minPrice.toStringAsFixed(2)) {
        text = minPrice.toStringAsFixed(1);
      } else if (value.toStringAsFixed(2) == medianPrice.toStringAsFixed(2)) {
        text = medianPrice.toStringAsFixed(1);
      } else if (value.toStringAsFixed(2) == maxPrice.toStringAsFixed(2)) {
        text = maxPrice.toStringAsFixed(1);
      } else {
        return Container();
      }
    } else if (maxPrice > 2 && maxPrice < 100) {
      if (value.toStringAsFixed(2) == minPrice.toStringAsFixed(2)) {
        text = minPrice.toStringAsFixed(2);
      } else if (value.toStringAsFixed(2) == medianPrice.toStringAsFixed(2)) {
        text = medianPrice.toStringAsFixed(2);
      } else if (value.toStringAsFixed(2) == maxPrice.toStringAsFixed(2)) {
        text = maxPrice.toStringAsFixed(2);
      } else {
        return Container();
      }
    } else {
      if (value == minPrice) {
        text = minPrice.toString();
      } else if (value == medianPrice) {
        text = medianPrice.toString();
      } else if (value == maxPrice) {
        text = maxPrice.toString();
      } else {
        return Container();
      }
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: const Image(
            image: AssetImage('assets/gradient.jpg'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: MediaQuery.of(context).size.height / 2,
                centerTitle: true,
                collapsedHeight: MediaQuery.of(context).size.height / 2,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    color: Color(0xff232d37),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(LineChartData(
                      minY: minPrice.toDouble(),
                      maxY: maxPrice.toDouble(),
                      lineTouchData: LineTouchData(enabled: true),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1)),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: interval,
                            getTitlesWidget: leftTitleWidgets,
                            reservedSize: 42,
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: priceData,
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              ColorTween(
                                      begin: gradientColors[0],
                                      end: gradientColors[1])
                                  .lerp(0.2)!,
                              ColorTween(
                                      begin: gradientColors[0],
                                      end: gradientColors[1])
                                  .lerp(0.2)!, //lerp is used for transition
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: ListView.builder(
                      physics:
                          const ClampingScrollPhysics(), //prevents last element from being out of bounds
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const Card(
                          color: Colors.transparent,
                          child: ListTile(
                              title: Text(
                                'Breaking News',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                  'Bitcoin Enthusiast Micheal Saylor quits his position as CEO',
                                  style: TextStyle(color: Colors.white))),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}


/*if (maxPrice >= 10000) {
      if (value.toInt() == tempMin.toInt()) {
        text = (tempMin / 1000).toStringAsFixed(1).toString() + 'K';
        tempMin = -1;
      } else if (value.toInt() == tempmed.toInt()) {
        text = (tempmed / 1000).toStringAsFixed(1).toString() + 'K';
        tempmed = -1;
      } else if (value.toInt() == tempMax.toInt()) {
        text = (tempMax / 1000).toStringAsFixed(1).toString() + 'K';
        tempMax = -1;
      } else {
        return Container();
      }
    } else if (maxPrice >= 1000) {
      if (value.toInt() == tempMin.toInt()) {
        text = (tempMin / 1000).toStringAsFixed(2).toString() + 'K';
        tempMin = -1;
        print('Min');
        print(value);
      } else if (value.toInt() == tempmed.toInt()) {
        text = (tempmed / 1000).toStringAsFixed(2).toString() + 'K';
        tempmed = -1;
        print('Median');
        print(value);
      } else if (value.toInt() == tempMax.toInt()) {
        tempMax = -1;
        text = (tempMax / 1000).toStringAsFixed(2).toString() + 'K';
        //maxPrice = -1;
        print('Max');
        print(value);
      } else {
        return Container();
      }
    } else {
      if (value == tempMin) {
        text = tempMin.toString();
      } else if (value.toInt() == tempmed) {
        text = tempmed.toString();
      } else if (value.toInt() == tempMax) {
        text = tempMax.toString();
      } else {
        return Container();
      }
    }*/