import 'package:cryptoalert/screens/homepage.dart';
import 'package:cryptoalert/screens/details.dart';
import 'package:cryptoalert/screens/loader.dart';
import 'package:cryptoalert/screens/CryptoConversion.dart';
import 'package:cryptoalert/screens/AssetsWallet.dart';
import 'package:flutter/material.dart';
import 'package:cryptoalert/screens/ErrorScreen.dart';

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
        '/initial': (context) => const InitialPage(),
        '/details': (context) => const CurrencyDetails(),
        '/convert': (context) => const Conversion(),
        '/wallet': (context) => const Wallet(),
        '/errpage': (context) =>const ErrorScreen(),
        //'/news' : (context) => const NewsDetail(),
        ///details': (context) => const LineChartSample2(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int selectedpage = 0;
  final _pageNo = [
    const HomePage(),
    const Conversion(),
    const Wallet(),
  ];
  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedpage,
        children: <Widget>[
          Navigator(
            key: _page1,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const HomePage(),
            ),
          ),
          Navigator(
            key: _page2,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const Conversion(),
            ),
          ),
          Navigator(
            key: _page3,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const Wallet(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gradient.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.blue,
          //selectedItemColor: Colors.white,
          backgroundColor: Colors.transparent.withOpacity(0.1),
          onTap: (int index) {
            setState(() {
              selectedpage = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              label: 'Convert',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment_bank),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
