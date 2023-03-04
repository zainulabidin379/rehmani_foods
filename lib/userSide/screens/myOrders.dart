import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  var firestore = FirebaseFirestore.instance;
  int orderCount = 0;
  Future getOrders() async {
    QuerySnapshot qn = await firestore
        .collection('myOrders')
        .doc('orders')
        .collection(uid)
        .orderBy('timestamp', descending: true)
        .get();

    return qn.docs;
  }

  File _image;
  final picker = ImagePicker();
  getImage(BuildContext context, String id) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      uploadImageToFirebase(id);
    } else {
      Get.snackbar(
        '',
        "Please select an image and try again",
        titleText: Text('No Image Selected',
            style: TextStyle(
                color: kPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
        duration: Duration(seconds: 4),
        backgroundColor: kWhite,
        colorText: kBlack,
        borderRadius: 10,
      );
    }
  }

  Future uploadImageToFirebase(String id) async {
    String fileName = basename(Uuid().v4());
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      String url = await firebaseStorageRef.getDownloadURL();
      FirebaseFirestore.instance.collection('pendingOrders').doc(id).update({
        "paymentScreenshot": url,
      });
      FirebaseFirestore.instance
          .collection('myOrders')
          .doc('orders')
          .collection(uid)
          .doc(id)
          .update({
        "paymentScreenshot": url,
      });
      setState(() {});
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Orders',
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
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          FutureBuilder<dynamic>(
              future: getOrders(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimary)));
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        Builder(builder: (context) {
                          if (snapshot.data[i]['totalItems'] == 1)
                            return orderCard(
                              context,
                              size,
                              snapshot.data[i]['id'],
                              snapshot.data[i]['orderID'],
                              "${snapshot.data[i]['item1_name']}",
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 2)
                            return orderCard(
                              context,
                              size,
                              snapshot.data[i]['id'],
                              snapshot.data[i]['orderID'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}",
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 3)
                            return orderCard(
                              context,
                              size,
                              snapshot.data[i]['id'],
                              snapshot.data[i]['orderID'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}, ${snapshot.data[i]['item3_name']}",
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 4)
                            return orderCard(
                              context,
                              size,
                              snapshot.data[i]['id'],
                              snapshot.data[i]['orderID'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}, ${snapshot.data[i]['item3_name']}, ${snapshot.data[i]['item4_name']}",
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['timestamp'],
                            );
                          if (orderCount == 0)
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text('Noting to show here!',
                                    style: kBodyText.copyWith(
                                        fontSize: size.width * 0.05)),
                              ),
                            );
                          else
                            return Container();
                        }),
                    ],
                  );
                }
              }),
        ]),
      ),
    );
  }

  Widget orderCard(
      BuildContext context,
      Size size,
      String id,
      String orderId,
      String name,
      String totalBill,
      String status,
      String paymentScreenshot,
      Timestamp date) {
    orderCount++;
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
        //     )).then((_) {
        //   setState(() {
        //     getCartItems();
        //   });
        // });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Container(
            width: size.width * 0.95,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kPrimary, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: AutoSizeText('Order ID: $orderId',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontSize: 15, color: kGrey)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 10, right: 10),
                      child: AutoSizeText(
                          DateTimeFormat.format(date.toDate(),
                              format: DateTimeFormats.american),
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontSize: 15, color: kGrey)),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 5),
                      child: AutoSizeText('Item(s):',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, right: 10),
                          child: Text(name, maxLines: 2, style: kBodyText),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 5),
                      child: AutoSizeText('Status:',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, right: 10),
                          child: AutoSizeText(status,
                              maxLines: 2,
                              style: kBodyText.copyWith(color: kPrimary)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 5),
                      child: AutoSizeText('Total Bill:',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, right: 10),
                          child: Text('Rs. $totalBill/-',
                              style: kBodyText.copyWith(color: kPrimary)),
                        ),
                      ),
                    ),
                  ],
                ),
                (status == 'Pending Confirmation')
                    ? Column(
                        children: [
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 15),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: kBodyText,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Pay ',
                                              style: TextStyle(color: kBlack)),
                                          TextSpan(
                                              text:
                                                  'Rs. ${(double.parse(totalBill) * 0.2).toInt()}/- ',
                                              style:
                                                  TextStyle(color: kPrimary)),
                                          TextSpan(
                                              text: 'on ',
                                              style: TextStyle(color: kBlack)),
                                          TextSpan(
                                              text: 'Easypaisa ',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                          TextSpan(
                                              text: 'to confirm your order.',
                                              style: TextStyle(color: kBlack)),
                                        ]))
                                // Text('Pay Rs. ${double.parse(totalBill) * 0.2} on easypaisa to comfirm your order.',
                                //     style: kBodyText.copyWith(color: kBlack)),
                                ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 5),
                                child: AutoSizeText('Account #:',
                                    maxLines: 2,
                                    style: kBodyText.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                child: Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 5,
                                    ),
                                    child: Text('03001234567',
                                        style: kBodyText.copyWith(
                                            color: kPrimary)),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                      height: 25,
                                      width: 40,
                                      color: kWhite,
                                      child: Icon(Icons.copy,
                                          size: 20, color: Colors.grey)),
                                ),
                                onTap: () {
                                  ClipboardManager.copyToClipBoard(
                                          '03001234567')
                                      .then((result) {
                                    Get.snackbar(
                                      '',
                                      'Transfer Rs. ${(double.parse(totalBill) * 0.2).toInt()} to this Easypaisa account.',
                                      titleText: Text('Account Number Copied',
                                          style: TextStyle(
                                              color: kPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: kWhite,
                                      colorText: kBlack,
                                      borderRadius: 10,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: Column(
                              children: [
                                (paymentScreenshot == null)
                                    ? SizedBox()
                                    : Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.zero,
                                              bottomRight: Radius.zero,
                                            ),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    paymentScreenshot))),
                                      ),
                                GestureDetector(
                                  onTap: () => getImage(context, id),
                                  child: Container(
                                    height: 40,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: (paymentScreenshot ==
                                                null)
                                            ? BorderRadius.circular(50)
                                            : BorderRadius.only(
                                                topLeft: Radius.zero,
                                                topRight: Radius.zero,
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              )),
                                    child: Center(
                                        child: Text(
                                            (paymentScreenshot == null)
                                                ? 'Upload Payment Screenshot'
                                                : 'Upload New',
                                            style: TextStyle(
                                                color: kWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  kPrimary))),
                                );
                                await FirebaseFirestore.instance
                                    .collection('pendingOrders')
                                    .doc(id)
                                    .delete();

                                await FirebaseFirestore.instance
                                    .collection('myOrders')
                                    .doc('orders')
                                    .collection(uid)
                                    .doc(id)
                                    .delete();
                                Navigator.pop(context);
                                Navigator.pop(context);

                                Get.snackbar(
                                  '',
                                  'Your order is cancelled',
                                  titleText: Text('Order Cancelled',
                                      style: TextStyle(
                                          color: kPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: kWhite,
                                  colorText: kBlack,
                                  borderRadius: 10,
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel Order',
                                    style: kBodyText.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
