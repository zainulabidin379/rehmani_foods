import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/screens/screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class EditMenu extends StatefulWidget {
  final String id;
  final String menuName;
  final double rate;
  final String persons;
  EditMenu({Key key, this.id, this.menuName, this.rate, this.persons})
      : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _persons = new TextEditingController();
  double totalAmount = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _persons.dispose();
    super.dispose();
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
    (widget.persons == null)
        ? _persons.clear()
        : _persons.text = widget.persons;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Choose Menu Details',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.width * 0.05),
                  Text(widget.menuName,
                      style: kBodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.07)),
                  SizedBox(height: size.width * 0.01),
                  Text('Enter total number of persons',
                      textAlign: TextAlign.center,
                      style: kBodyText.copyWith(fontSize: size.width * 0.04)),
                  SizedBox(height: size.width * 0.01),
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: TextFormField(
                                controller: _persons,
                                onChanged: (val) {
                                  setState(() {
                                    totalAmount =
                                        double.parse(val) * widget.rate;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                style: kBodyText,
                                textAlign: TextAlign.center,
                                cursorColor: kPrimary,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  hintText: 'Enter number of persons',
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 19),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide:
                                        BorderSide(color: kPrimary, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide:
                                        BorderSide(color: kPrimary, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide:
                                        BorderSide(color: kPrimary, width: 1.5),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.isEmpty)
                                    return 'Please enter required quantity';

                                  if (int.parse(val) < 200) {
                                    return 'This menu only available for more than 200 persons';
                                  }
                                  return null;
                                }),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (totalAmount == 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Per Person Rate: ',
                              style: kBodyText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.07)),
                          Flexible(
                            child: Text('Rs. ${widget.rate.truncate()}',
                                style: kBodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.07,
                                    color: kPrimary)),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total Amount: ',
                              style: kBodyText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.07)),
                          Flexible(
                            child: Text('Rs. ${totalAmount.truncate()}',
                                style: kBodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.07,
                                    color: kPrimary)),
                          ),
                        ],
                      ),
                SizedBox(
                  height: size.height * 0.01,
                ),
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
                      var collectionRef = await FirebaseFirestore.instance
                          .collection('cart')
                          .doc('carts')
                          .collection(uid)
                          .doc(widget.id)
                          .get();
                      if (collectionRef.exists) {
                        FirebaseFirestore.instance
                            .collection('cart')
                            .doc('carts')
                            .collection(uid)
                            .doc(widget.id)
                            .update({
                          "totalQuantity": '${_persons.text}',
                          "totalAmount": totalAmount,
                        }).then((_) async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Get.snackbar(
                            'Successfully updated',
                            'Menu successfully updated',
                            duration: Duration(seconds: 4),
                            backgroundColor: kWhite,
                            colorText: kPrimary,
                            borderRadius: 10,
                          );
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection('cart')
                            .doc('carts')
                            .collection(uid)
                            .doc(widget.id)
                            .set({
                          "id": widget.id,
                          "serviceName": widget.menuName,
                          "rate": widget.rate,
                          "totalQuantity": '${_persons.text}',
                          "totalAmount": totalAmount,
                          "unit": 'Persons',
                          "image": 'null',
                          "type": 'menu',
                        }).then((_) async {
                          // await FirebaseFirestore.instance
                          //     .collection('users')
                          //     .get()
                          //     .then((value) {
                          //   //var id = Uuid().v4();

                          //   for (var i = 0; i < value.docs.length; i++) {
                          //     FirebaseFirestore.instance
                          //         .collection('notifications')
                          //         .doc('notificationsDoc')
                          //         .collection(value.docs[i]['uid'])
                          //         .doc(uid)
                          //         .set({
                          //           "id": widget.id,
                          //           "timestamp": DateTime.now(),
                          //           "isRead": false,
                          //           "notification":
                          //               'A new event has been added, go and check it out in Events section.',
                          //         })
                          //         .then((_) {})
                          //         .catchError((onError) {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //               SnackBar(content: Text(onError)));
                          //         });
                          //   }
                          // });

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Get.snackbar(
                            'Successfully Added',
                            'Menu successfully added to cart.',
                            duration: Duration(seconds: 4),
                            backgroundColor: kWhite,
                            colorText: kPrimary,
                            borderRadius: 10,
                          );
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                      }
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
                        'Add To Cart',
                        style: kBodyText.copyWith(
                            fontWeight: FontWeight.bold, color: kWhite),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
