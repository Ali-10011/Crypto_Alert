import 'package:cryptoalert/homepage.dart';
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
        '/': (context) => LoadingState(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
