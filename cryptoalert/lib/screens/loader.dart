import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({Key? key}) : super(key: key);

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> {

  void WaitForData() async {
    await cryptorequest();
    Navigator.pushReplacementNamed(context, '/home');
  }
@override
  void initState() {
    super.initState();
    WaitForData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 50.0,
        )));
  }
}
