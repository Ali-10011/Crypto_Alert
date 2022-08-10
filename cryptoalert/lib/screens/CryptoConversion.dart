import 'package:flutter/material.dart';

class Conversion extends StatefulWidget {
  const Conversion({ Key? key }) : super(key: key);

  @override
  State<Conversion> createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('Conversion'),
      ),
    );
  }
}