import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:cryptoalert/models/ChartData.dart';

class CurrencyDetails extends StatefulWidget {
  const CurrencyDetails({Key? key}) : super(key: key);

  @override
  State<CurrencyDetails> createState() => _CurrencyDetailsState();
}

class _CurrencyDetailsState extends State<CurrencyDetails> {
  List<FlSpot> priceData = [];
  double minPrice = 10000000;
  double maxPrice = -1;
  double medianPrice = 0;
  void initState() {
    _cryptochartDatarequest();
  }

  @override
  Future<void> _cryptochartDatarequest() async {
    Map<dynamic, dynamic> jsonResponse;
    try {
      Map<String, String> queryParams = {
        'vs_currency': 'usd',
        'days': '1',
        'interval': 'hourly'
      };
      var url = Uri.https('api.coingecko.com',
          '/api/v3/coins/bitcoin/market_chart', queryParams);
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
          LChartData.add(ChartData(
              timeStamp: jsonResponse['prices'][i][0].toString(),
              price: jsonResponse['prices'][i][1].toString(),
              volume: jsonResponse['total_volumes'][i][1].toString(),
              marketCap: jsonResponse['market_caps'][i][1].toString()));
        }

        priceData = [];

        for (int i = 0; i < LChartData.length; i++) {
          double temp = double.parse(LChartData[i].price);
          if (minPrice > temp) {
            minPrice = temp;
          }
          if (temp > maxPrice) {
            maxPrice = temp;
          }
          String temp2 = temp.toStringAsFixed(2);
          priceData.add(FlSpot(i.toDouble(), double.parse(temp2)));
        }

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
          color: Color(0xff232d37)),
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(LineChartData(
          // lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          /* gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: (maxPrice - minPrice) / 2,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
          ),*/
          lineBarsData: [
            LineChartBarData(
              spots: priceData,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!,
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
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
                  colors: [
                    ColorTween(begin: gradientColors[0], end: gradientColors[1])
                        .lerp(0.2)!
                        .withOpacity(0.1),
                    ColorTween(begin: gradientColors[0], end: gradientColors[1])
                        .lerp(0.2)!
                        .withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        )),
      ),
    ));
  }
}
