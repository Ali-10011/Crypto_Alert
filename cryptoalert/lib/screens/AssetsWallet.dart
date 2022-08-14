import 'package:flutter/material.dart';


class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();
  
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Text('Wallet')),
    );
  }
}
