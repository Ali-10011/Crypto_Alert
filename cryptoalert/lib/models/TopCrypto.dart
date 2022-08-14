import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cryptoalert/global/global.dart' as globals;

class CryptoData {
  late String ID;
  late String Symbol;
  late String current_price;
  late String Market_Cap;
  late String Daily_Change;
  late String Cap_Daily_Change;
  late String Icon_Url;
  late List<dynamic> SparklineData;

  CryptoData(
      {required this.ID,
      required this.Symbol,
      required this.current_price,
      required this.Daily_Change,
      required this.Market_Cap,
      required this.Cap_Daily_Change,
      required this.Icon_Url,
      required this.SparklineData});
}


List<CryptoData> TopData = [];
