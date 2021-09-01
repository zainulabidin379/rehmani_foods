import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/screens/screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double subTotal = 0;
  double total = 0;
  double shipping = 0;
  int cartItemsCount = 0;

  Future getItems() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('cart').doc('carts').collection(uid).get();

    return qn.docs;
  }

  calculateBill() async {
    total = 0;
    subTotal = 0;
    String uid = FirebaseAuth.instance.currentUser.uid;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('cart').doc('carts').collection(uid).get();
    for (var i = 0; i < qn.docs.length; i++) {
      setState(() {
        subTotal = subTotal + qn.docs[i]['totalAmount'];
      });
    }
    setState(() {
      total = subTotal + shipping;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateBill();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart',
            style: GoogleFonts.dosis(
              color: kPrimary,
              fontSize: 27,
            )),
        backgroundColor: kBg,
        elevation: 0,
        //back Button
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Icon(Icons.arrow_back_ios, color: kBlack, size: 27),
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  FutureBuilder<dynamic>(
                      future: getItems(),
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
                              for (var i = 0; i < snapshot.data.length; i++)
                                (snapshot.data[i]['type'] == 'menu')
                                    ? menuCartItem(
                                        size,
                                        snapshot.data[i]['id'],
                                        snapshot.data[i]['image'],
                                        snapshot.data[i]['serviceName'],
                                        snapshot.data[i]['totalQuantity'],
                                        snapshot.data[i]['totalAmount']
                                            .toDouble(),
                                        snapshot.data[i]['rate'].toDouble(),
                                        snapshot.data[i]['unit'],
                                      )
                                    : cartItem(
                                        size,
                                        snapshot.data[i]['id'],
                                        snapshot.data[i]['image'],
                                        snapshot.data[i]['serviceName'],
                                        snapshot.data[i]['totalQuantity'],
                                        snapshot.data[i]['totalAmount']
                                            .toDouble(),
                                        snapshot.data[i]['minWeight']
                                            .toDouble(),
                                        snapshot.data[i]['rate'].toDouble(),
                                        snapshot.data[i]['serving'].toDouble(),
                                        snapshot.data[i]['unit'],
                                        snapshot.data[i]['type'],
                                      ),
                              (cartItemsCount == 0)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Text('Cart is Empty!',
                                          style: kBodyText.copyWith(
                                              fontSize: size.width * 0.05)),
                                    )
                                  : SizedBox(),
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
              billDetailsCard(size),
              checkoutButton(size),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget checkoutButton(Size size) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.to(()=> AddressDetail(totalBill: total));
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
              'Proceed to Checkout',
              style: kBodyText.copyWith(
                  fontWeight: FontWeight.bold, color: kWhite),
            ),
          ),
        ),
      ),
    );
  }

  Padding billDetailsCard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        height: 190,
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bill Details',
                  style: kBodyText.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimary)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: kBodyText),
                    Text('Free', style: kBodyText.copyWith(color: kPrimary)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: kBodyText),
                    Text('Rs. ${subTotal.truncate()}', style: kBodyText),
                  ],
                ),
              ),
              Divider(
                color: kGrey,
                thickness: 0.8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: kBodyText.copyWith(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Rs. ${total.truncate()}',
                        style: kBodyText.copyWith(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cartItem(
    Size size,
    String id,
    String image,
    String serviceName,
    String totalquantity,
    double totalAmount,
    double minWeight,
    double rate,
    double serving,
    String unit,
    String type,
  ) {
    cartItemsCount++;
    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetails(
              id: id,
              itemName: serviceName,
              rate: rate,
              minWeight: minWeight,
              unit: unit,
              serving: serving,
              type: type,
              image: image,
              weight:  totalquantity,
            ));
        // Get.snackbar('$serviceName Added!',
        //     '$serviceName successfully added to cart.',
        //     duration: Duration(seconds: 4),
        //     backgroundColor: kBg,
        //     colorText: kBlack,
        //     borderWidth: 2,
        //     borderColor: kPrimary,
        //     borderRadius: 50);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Container(
            height: 100,
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
                Row(
                  children: [
                    Container(
                      height: 100,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              width: size.width * 0.5,
                              child: AutoSizeText(serviceName,
                                  maxLines: 1,
                                  style: kBodyText.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Text('$totalquantity',
                              style: kBodyText.copyWith(
                                fontSize: 19,
                              )),
                          Text('Rs. ${totalAmount.truncate()}',
                              style: kBodyText.copyWith(
                                  fontSize: 19, color: kPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    String uid = FirebaseAuth.instance.currentUser.uid;
                    FirebaseFirestore.instance
                        .collection('cart')
                        .doc('carts')
                        .collection(uid)
                        .doc(id)
                        .delete();
                    setState(() {
                      --cartItemsCount;
                    });
                    calculateBill();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.trashAlt,
                          color: Colors.redAccent,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuCartItem(
    Size size,
    String id,
    String image,
    String serviceName,
    String totalquantity,
    double totalAmount,
    double rate,
    String unit,
  ) {
    cartItemsCount++;
    return GestureDetector(
      onTap: () {
        Get.to(() => EditMenu(
              id: id,
              menuName: serviceName,
              rate: rate,
              persons: totalquantity.toString(),
            ));
        // Get.snackbar('$serviceName Added!',
        //     '$serviceName successfully added to cart.',
        //     duration: Duration(seconds: 4),
        //     backgroundColor: kBg,
        //     colorText: kBlack,
        //     borderWidth: 2,
        //     borderColor: kPrimary,
        //     borderRadius: 50);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Container(
            height: 100,
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
                Row(
                  children: [
                    Container(
                      height: 100,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              width: size.width * 0.5,
                              child: AutoSizeText(serviceName,
                                  maxLines: 1,
                                  style: kBodyText.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Text('$totalquantity $unit',
                              style: kBodyText.copyWith(
                                fontSize: 19,
                              )),
                          Text('Rs. ${totalAmount.truncate()}',
                              style: kBodyText.copyWith(
                                  fontSize: 19, color: kPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    String uid = FirebaseAuth.instance.currentUser.uid;
                    FirebaseFirestore.instance
                        .collection('cart')
                        .doc('carts')
                        .collection(uid)
                        .doc(id)
                        .delete();
                    setState(() {
                      --cartItemsCount;
                    });
                    calculateBill();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.trashAlt,
                          color: Colors.redAccent,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
