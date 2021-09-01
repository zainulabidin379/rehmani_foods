import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/screens/screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class ItemDetails extends StatefulWidget {
  final String id;
  final String type;
  final String itemName;
  final double rate;
  final double minWeight;
  final String unit;
  final double serving;
  final String image;
  final String weight;
  ItemDetails(
      {Key key,
      this.id,
      this.type,
      this.itemName,
      this.minWeight,
      this.rate,
      this.unit,
      this.image,
      this.serving,
      this.weight})
      : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _weight = new TextEditingController();
  double totalAmount = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _weight.dispose();
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
    (widget.weight == null) ? _weight.clear() : _weight.text = widget.weight;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Choose Item Details',
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
                  Container(
                    height: size.height * 0.17,
                    width: size.height * 0.17,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.image))),
                  ),
                  SizedBox(height: size.width * 0.05),
                  Text(widget.itemName,
                      style: kBodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.07)),
                  SizedBox(height: size.width * 0.01),
                  (widget.type == 'cooking')
                      ? Text(
                          '5 ${widget.unit} ${widget.itemName} is enough for ${widget.serving.truncate()} Persons',
                          textAlign: TextAlign.center,
                          style:
                              kBodyText.copyWith(fontSize: size.width * 0.04))
                      : Text('Enter required quantity of item',
                          textAlign: TextAlign.center,
                          style:
                              kBodyText.copyWith(fontSize: size.width * 0.04)),
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
                                controller: _weight,
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
                                  hintText: (widget.type == 'cooking')
                                      ? 'Enter required Quantity in ${widget.unit}'
                                      : 'Enter required Quantity',
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
                                    return (widget.type == 'cooking')
                                        ? 'Please enter required weight'
                                        : 'Please enter required quantity';

                                  if (int.parse(val) < widget.minWeight) {
                                    return 'Minimum quantity is ${widget.minWeight.truncate()} ${widget.unit}';
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
                          (widget.type == 'cooking')
                              ? Text('Per ${widget.unit} Rate: ',
                                  style: kBodyText.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.07))
                              : Text('Per Item Rate: ',
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
                        if (widget.type == 'cooking') {
                          FirebaseFirestore.instance
                              .collection('cart')
                              .doc('carts')
                              .collection(uid)
                              .doc(widget.id)
                              .update({
                            "totalQuantity": '${_weight.text} ${widget.unit}',
                            "totalAmount": totalAmount,
                          }).then((_) async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Get.snackbar(
                              'Successfully Updated',
                              '${widget.itemName} successfully updated in cart.',
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
                              .update({
                            "totalQuantity": '${_weight.text} ${widget.unit}',
                            "totalAmount": totalAmount,
                          }).then((_) async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Get.snackbar(
                              'Successfully updated',
                              '${widget.itemName} successfully updated in cart.',
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
                      } else {
                        if (widget.type == 'cooking') {
                          FirebaseFirestore.instance
                              .collection('cart')
                              .doc('carts')
                              .collection(uid)
                              .doc(widget.id)
                              .set({
                            "id": widget.id,
                            "serviceName": widget.itemName,
                            "rate": widget.rate,
                            "minWeight": widget.minWeight,
                            "unit": widget.unit,
                            "serving": widget.serving,
                            "image": widget.image,
                            "totalQuantity": '${_weight.text} ${widget.unit}',
                            "totalAmount": totalAmount,
                            "type": widget.type,
                          }).then((_) async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Get.snackbar(
                              'Successfully Added',
                              '${widget.itemName} successfully added to cart.',
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
                            "serviceName": widget.itemName,
                            "rate": widget.rate,
                            "image": widget.image,
                            "totalQuantity": '${_weight.text}',
                            "totalAmount": totalAmount,
                            "type": widget.type,
                            "unit": widget.unit,
                            "minWeight": widget.minWeight,
                            "serving": widget.serving,
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
                            Get.snackbar(
                              'Successfully Added',
                              '${widget.itemName} successfully added to cart.',
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
