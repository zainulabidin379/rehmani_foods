import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class EventManagement extends StatefulWidget {
  EventManagement({Key key}) : super(key: key);

  @override
  _EventManagementState createState() => _EventManagementState();
}

class _EventManagementState extends State<EventManagement> {
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
        title: Text('Event Management',
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
          eventsCard(size, () {
            Get.to(() => Mehndi()).then((_) {
              setState(() {
                getCartItems();
              });
            });
          }, 'Mehndi', 'mehndi.jpg'),
          SizedBox(height: 5),
          eventsCard(size, () {
            Get.to(() => Walima()).then((_) {
              setState(() {
                getCartItems();
              });
            });
          }, 'Barat/Walima', 'walima.jpg'),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width * 0.95,
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimary),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                      color: kWhite,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Live Tandoor',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Plater Service',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Mineral Water',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Soup',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Cold Drink',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  '- Kashmiri Tea',
                                  style: kBodyText.copyWith(
                                    fontSize: 20,
                                    color: kBlack,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: size.width * 0.95,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.zero,
                        topLeft: Radius.zero,
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Extra Charges',
                        style: kBodyText.copyWith(
                            fontSize: 25,
                            color: kWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget eventsCard(Size size, Function onTap, String event, String image) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Center(
          child: Column(
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/$image")),
                  color: kWhite,
                ),
              ),
              Container(
                height: 50,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.zero,
                    topLeft: Radius.zero,
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    event,
                    style: kBodyText.copyWith(
                        fontSize: 25,
                        color: kWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
