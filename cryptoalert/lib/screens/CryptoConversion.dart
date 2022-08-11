import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Conversion extends StatefulWidget {
  const Conversion({Key? key}) : super(key: key);

  @override
  State<Conversion> createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  final controller = TextEditingController(text: '03044791344');
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/gradient.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                      child: Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 100,
                            child: TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,7}')),
                                ],
                                decoration: InputDecoration(
                                    labelText: "whatever you want",
                                    hintText: "whatever you want",
                                    icon: Icon(Icons.phone_iphone)))),
                      ),
                    ),
                  ],
                ))));
  }
}
