import 'package:cryptoalert/screens/homepage.dart';
import 'package:cryptoalert/screens/details.dart';
import 'package:cryptoalert/screens/loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cryptoalert',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingState(),
        '/home': (context) => const HomePage(),
        '/details': (context) => const CurrencyDetails(),
        //'/news' : (context) => const NewsDetail(),
        ///details': (context) => const LineChartSample2(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
