import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cryptoalert/models/TopCrypto.dart';
import 'package:cryptoalert/screens/homepage.dart';

class Conversion extends StatefulWidget {
  const Conversion({Key? key}) : super(key: key);

  @override
  State<Conversion> createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  final controller = TextEditingController(text: '');
  bool IsTop = true;
  final controllerResult = TextEditingController(text: '');
  String testTitle1 = 'Bitcoin';
  String testTitle2 = 'Ethereum';
  String testUrl1 =
      'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579';
  String testUrl2 =
      "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880";
  double testPrice1 = double.parse(TopData[0].current_price);
  double testPrice2 = double.parse(TopData[1].current_price);
  double factor = double.parse(TopData[0].current_price) /
      double.parse(TopData[1].current_price);
  void dispose() {
    controller.dispose();
    controllerResult.dispose();
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
                child: Center(
                  child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.2,
                              50,
                              MediaQuery.of(context).size.width * 0.2,
                              100),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                image: DecorationImage(
                                  image: AssetImage("assets/gradient.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      IsTop = true;
                                      BarModalSheet(context, IsTop);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 8,
                                            backgroundImage:
                                                NetworkImage(testUrl1),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(testTitle1,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                      onChanged: (_) {
                                        // print('Change');
                                        if (controller.text != '') {
                                          //print('Inside');
                                          controllerResult.text =
                                              (double.parse(controller.text) *
                                                      factor)
                                                  .toString();
                                        } else {
                                          controllerResult.text = '';
                                        }
                                      },
                                      style: TextStyle(color: Colors.white),
                                      controller: controller,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,7}')),
                                      ],
                                      decoration: const InputDecoration(
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          labelText: "Amount",
                                          hintText: "Enter your amount",
                                          icon: Icon(Icons
                                              .arrow_forward_ios_rounded))),
                                ],
                              )),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                String swap = testUrl1;
                                testUrl1 = testUrl2;
                                testUrl2 = swap;
                                swap = testTitle1;
                                testTitle1 = testTitle2;
                                testTitle2 = swap;
                                double swapdouble = testPrice1;
                                testPrice1 = testPrice2;
                                testPrice2 = swapdouble;
                                factor = testPrice1 / testPrice2;
                                 if (controller.text != '') {
                                          //print('Inside');
                                          controllerResult.text =
                                              (double.parse(controller.text) *
                                                      factor)
                                                  .toString();
                                        }
                              });
                            },
                            icon: const Icon(
                              Icons.change_circle,
                              size: 30,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.2,
                              50,
                              MediaQuery.of(context).size.width * 0.2,
                              100),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                image: DecorationImage(
                                  image: AssetImage("assets/gradient.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      IsTop = false;

                                      BarModalSheet(context, IsTop);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 8,
                                            backgroundImage:
                                                NetworkImage(testUrl2),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(testTitle2,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                      controller: controllerResult,
                                      enabled: false,
                                      style: TextStyle(color: Colors.white),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,7}')),
                                      ],
                                      decoration: const InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          //labelText: "Amount",
                                          //hintText: "Enter your amount",
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.green,
                                          ))),
                                ],
                              )),
                        ),
                      ]),
                ))));
  }

  Future<dynamic> BarModalSheet(BuildContext context, bool IsUpper) {
    return showBarModalBottomSheet(
        backgroundColor: Colors.transparent,
        expand: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/gradient.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView.builder(
                    physics:
                        const ClampingScrollPhysics(), //prevents last element from being out of bounds
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: TopData.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (IsUpper) {
                              testUrl1 = TopData[index].Icon_Url;
                              testPrice1 =
                                  double.parse(TopData[index].current_price);
                              factor = testPrice1 / testPrice2;
                              testTitle1 = TopData[index].ID.capitalize();
                                
                            } else {
                              testUrl2 = TopData[index].Icon_Url;
                              testPrice2 =
                                  double.parse(TopData[index].current_price);
                              factor = testPrice1 / testPrice2;
                              testTitle2 = TopData[index].ID.capitalize();
                            }
                             if (controller.text != '') {
                                          //print('Inside');
                                          controllerResult.text =
                                              (double.parse(controller.text) *
                                                      factor)
                                                  .toString();
                                        }
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white60, Colors.white10]),
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(width: 0.5, color: Colors.white30),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 8,
                                  backgroundImage:
                                      NetworkImage(TopData[index].Icon_Url),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('${TopData[index].ID.capitalize()}',
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '${TopData[index].Symbol.toString().toUpperCase()}',
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('${TopData[index].current_price}',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ));
  }
}
