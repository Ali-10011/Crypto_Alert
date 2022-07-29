import 'package:flutter/material.dart';

class CryptoCard extends StatefulWidget {
  //allows to pass parameters to the constructor
  const CryptoCard({Key? key}) : super(key: key);

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[100],
        shadowColor: Colors.transparent,
        elevation: 3.0,
        margin: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Container(
            margin: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Text('Hi')));
  }
}
