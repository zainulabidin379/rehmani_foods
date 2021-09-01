import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class MenuDetails extends StatefulWidget {
  final String id;
  final String name;
  final double rate;
  MenuDetails({Key key, this.id, this.name, this.rate}) : super(key: key);

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  Future getMenus() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('eventManagement')
        .doc(widget.id)
        .collection('menuItems')
        .get();

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
        title: Text('Menu Details',
            style: GoogleFonts.dosis(
              color: kPrimary,
              fontSize: 27,
            )),
        backgroundColor: kBg,
        elevation: 0,
        //Menu Button
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Icon(Icons.arrow_back_ios, color: kBlack, size: 27),
            )),

        //notification Icon
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<dynamic>(
                      future: getMenus(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(kPrimary)));
                        } else {
                          return Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: AutoSizeText('${widget.name} Includes',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: kBodyText.copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              for (var i = 0; i < snapshot.data.length; i++)
                                menuCard(
                                  size,
                                  snapshot.data[i]['id'],
                                  snapshot.data[i]['image'],
                                  snapshot.data[i]['itemName'],
                                  widget.rate,
                                ),
                            ],
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
          Column(
            children: [
              addToCartButton(size),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget addToCartButton(Size size) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          Get.to(() => EditMenu(
                id: widget.id,
                menuName: widget.name,
                rate: widget.rate,
              )).then((_) {
            setState(() {
              getCartItems();
            });
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          height: 50,
          width: size.width * 0.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: kPrimary,
          ),
          child: Center(
            child: Text(
              'Continue With This Menu',
              style: kBodyText.copyWith(
                  fontWeight: FontWeight.bold, color: kWhite),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuCard(
      Size size, String id, String image, String serviceName, double rate) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => ItemDetails(
        //       id: id,
        //       type: 'cooking',
        //       itemName: serviceName,
        //       rate: rate,
        //       minWeight: minWeight,
        //       unit: unit,
        //       serving: serving,
        //       image: image,
        //     ));
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.zero,
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.zero,
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(image))),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: AutoSizeText(serviceName,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: kBodyText.copyWith(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
