import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class Mehndi extends StatefulWidget {
  Mehndi({Key key}) : super(key: key);

  @override
  _MehndiState createState() => _MehndiState();
}

class _MehndiState extends State<Mehndi> {
  Future getServices() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('eventManagement').get();

    return qn.docs;
  }

  int cartItemsCount = 0;
  Future getCartItems() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('cart').doc('carts').collection(uid).get();
    setState(() {
      cartItemsCount = qn.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mehndi',
            style: GoogleFonts.dosis(
              color: kPrimary,
              fontSize: 27,
            )),
        backgroundColor: kBg,
        elevation: 0,
        //Back Button
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Icon(Icons.arrow_back_ios, color: kBlack, size: 27),
            )),

        //cart Icon
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              Get.to(() => Cart()).then((_) {
                setState(() {
                  getCartItems();
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 7.0),
                    child: Icon(
                      FontAwesomeIcons.shoppingCart,
                      size: 27,
                      color: kBlack,
                    ),
                  )),
                  Positioned(
                    top: 7,
                    right: 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(cartItemsCount.toString(),
                              style: TextStyle(fontSize: 16))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 5),
          FutureBuilder<dynamic>(
              future: getServices(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimary)));
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        (snapshot.data[i]['event'] == 'mehndi')
                            ? serviceCard(
                                size,
                                snapshot.data[i]['id'],
                                snapshot.data[i]['menu'],
                                snapshot.data[i]['rate'].toDouble(),
                              )
                            : SizedBox()
                    ],
                  );
                }
              }),
        ],
      )),
    );
  }

  Widget serviceCard(Size size, String id, String serviceName, double rate) {
    return GestureDetector(
      onTap: () {
        //Get.to(() => ItemDetails(itemName: serviceName, rate: rate, minWeight: minWeight, unit: unit,));
        Get.to(() => MenuDetails(
              id: id,
              name: serviceName,
              rate: rate,
            )).then((_) {
          setState(() {
            getCartItems();
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Container(
            height: 70,
            width: size.width * 0.95,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: AutoSizeText(serviceName,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: kBodyText.copyWith(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
