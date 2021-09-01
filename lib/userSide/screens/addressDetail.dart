import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:rehmani_foods/userSide/screens/homepage.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';

class AddressDetail extends StatefulWidget {
  final double totalBill;
  const AddressDetail({Key key, this.totalBill}) : super(key: key);

  @override
  _AddressDetailState createState() => _AddressDetailState();
}

class _AddressDetailState extends State<AddressDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _address = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Address Details',
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      style: kBodyText,
                      cursorColor: kPrimary,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Your Contact Number',
                        hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 19),
                        errorStyle: TextStyle(
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                      ),
                      validator: FieldValidator.multiple([
                        FieldValidator.required(
                            message: 'Contact Number is Required'),
                        FieldValidator.number(
                            message: 'Contact must be numbers only'),
                        FieldValidator.minLength(11,
                            message:
                                'Please enter a valid number (03001234567)'),
                        FieldValidator.maxLength(11,
                            message:
                                'Please enter a valid number (03001234567)'),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20),
                    child: TextFormField(
                      controller: _address,
                      style: kBodyText.copyWith(color: kBlack),
                      cursorColor: kPrimary,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: 2,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        hintText: 'Your Address',
                        hintStyle:
                            kBodyText.copyWith(fontSize: 20, color: kGrey),
                        errorStyle: TextStyle(
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                      ),
                      validator: FieldValidator.multiple([
                        FieldValidator.required(message: 'Address is Required'),
                        FieldValidator.minLength(6,
                            message: 'Please enter a valid address'),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(kPrimary))),
                      );

                      String uid = FirebaseAuth.instance.currentUser.uid;
                      String id = Uuid().v4();

                      QuerySnapshot qn = await FirebaseFirestore.instance
                          .collection('cart')
                          .doc('carts')
                          .collection(uid)
                          .get();
                      FirebaseFirestore.instance
                          .collection('myOrders')
                          .doc('orders')
                          .collection(uid)
                          .doc(id)
                          .set({
                        "id": id,
                        "orderID": randomNumeric(10),
                        "totalBill": '${widget.totalBill.truncate()}',
                        "contactNumber": _phone.text,
                        "address": _address.text,
                        "totalItems": qn.docs.length,
                        "status": 'Pending Confirmation',
                        "paymentScreenshot": null,
                        "timestamp": DateTime.now(),
                      }).then((_) {
                        for (var i = 0; i < qn.docs.length; i++) {
                          FirebaseFirestore.instance
                              .collection('myOrders')
                              .doc('orders')
                              .collection(uid)
                              .doc(id)
                              .update({
                            "item${i + 1}_name":
                                "${qn.docs[i]['serviceName']} (${qn.docs[i]['totalQuantity']})",
                          });
                          FirebaseFirestore.instance
                              .collection('myOrders')
                              .doc('orders')
                              .collection(uid)
                              .doc(id)
                              .collection('items')
                              .doc('item${i + 1}')
                              .set({
                            "item${i + 1}_name": qn.docs[i]['serviceName'],
                            "item${i + 1}_image": qn.docs[i]['image'],
                            "item${i + 1}_totalQuantity": qn.docs[i]
                                ['totalQuantity'],
                            "item${i + 1}_totalAmount": qn.docs[i]
                                ['totalAmount'],
                            "item${i + 1}_unit": qn.docs[i]['unit'],
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(onError)));
                          });
                        }

                        /////////////////
                        FirebaseFirestore.instance
                            .collection('pendingOrders')
                            .doc(id)
                            .set({
                          "id": id,
                          "uid": uid,
                          "orderID": randomNumeric(10),
                          "totalBill": '${widget.totalBill.truncate()}',
                          "contactNumber": _phone.text,
                          "address": _address.text,
                          "totalItems": qn.docs.length,
                          "paymentScreenshot": null,
                          "status": 'Pending Confirmation',
                          "timestamp": DateTime.now(),
                        }).then((_) {
                          for (var i = 0; i < qn.docs.length; i++) {
                            FirebaseFirestore.instance
                                .collection('pendingOrders')
                                .doc(id)
                                .update({
                              "item${i + 1}_name":
                                  "${qn.docs[i]['serviceName']} (${qn.docs[i]['totalQuantity']})",
                            });
                            FirebaseFirestore.instance
                                .collection('pendingOrders')
                                .doc(id)
                                .collection('items')
                                .doc('item${i + 1}')
                                .set({
                              "item${i + 1}_name": qn.docs[i]['serviceName'],
                              "item${i + 1}_image": qn.docs[i]['image'],
                              "item${i + 1}_totalQuantity": qn.docs[i]
                                  ['totalQuantity'],
                              "item${i + 1}_totalAmount": qn.docs[i]
                                  ['totalAmount'],
                              "item${i + 1}_unit": qn.docs[i]['unit'],
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(onError)));
                            });
                          }
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                        ////////////////////////
                        FirebaseFirestore.instance
                            .collection('cart')
                            .doc('carts')
                            .collection(uid)
                            .get()
                            .then((value) {
                          for (DocumentSnapshot ds in value.docs) {
                            ds.reference.delete();
                          }
                        });
                        Get.offAll(() => Homepage());
                        setState(() {});
                        Get.snackbar(
                          '',
                          "Your order is placed, check 'My Orders' section for order status.",
                          titleText: Text('Order Placed',
                              style: TextStyle(
                                  color: kPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          duration: Duration(seconds: 4),
                          backgroundColor: kWhite,
                          colorText: kBlack,
                          borderRadius: 10,
                        );
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError.toString())));
                      });

                      //   if (collectionRef.exists) {

                      //   } else {
                      //     FirebaseFirestore.instance
                      //         .collection('cart')
                      //         .doc('carts')
                      //         .collection(uid)
                      //         .doc(widget.id)
                      //         .set({
                      //       "id": widget.id,
                      //       "serviceName": widget.menuName,
                      //       "rate": widget.rate,
                      //       "totalQuantity": '${_persons.text}',
                      //       "totalAmount": totalAmount,
                      //       "unit": 'Persons',
                      //       "image": 'null',
                      //       "type": 'menu',
                      //     }).then((_) async {

                      //   }
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    height: 50,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kPrimary,
                    ),
                    child: Center(
                      child: Text(
                        'Place Order',
                        style: kBodyText.copyWith(
                            fontWeight: FontWeight.bold, color: kWhite),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
