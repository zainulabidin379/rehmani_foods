import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/adminSide/screens/adminHomepage.dart';
import 'package:rehmani_foods/adminSide/screens/screens.dart';
import '../shared/shared.dart';

class PendingOrders extends StatefulWidget {
  const PendingOrders({Key key}) : super(key: key);

  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  var firestore = FirebaseFirestore.instance;
  int orderCount = 0;
  Future getOrders() async {
    QuerySnapshot qn = await firestore
        .collection('pendingOrders')
        .orderBy('timestamp', descending: true)
        .get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pending Orders',
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
                              size,
                              snapshot.data[i]['orderID'],
                              snapshot.data[i]['id'],
                              snapshot.data[i]['uid'],
                              "${snapshot.data[i]['item1_name']}",
                              snapshot.data[i]['address'],
                              snapshot.data[i]['contactNumber'],
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['totalItems'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 2)
                            return orderCard(
                              size,
                              snapshot.data[i]['orderID'],
                              snapshot.data[i]['id'],
                              snapshot.data[i]['uid'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}",
                              snapshot.data[i]['address'],
                              snapshot.data[i]['contactNumber'],
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['totalItems'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 3)
                            return orderCard(
                              size,
                              snapshot.data[i]['orderID'],
                              snapshot.data[i]['id'],
                              snapshot.data[i]['uid'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}, ${snapshot.data[i]['item3_name']}",
                              snapshot.data[i]['address'],
                              snapshot.data[i]['contactNumber'],
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['totalItems'],
                              snapshot.data[i]['timestamp'],
                            );
                          else if (snapshot.data[i]['totalItems'] == 4)
                            return orderCard(
                              size,
                              snapshot.data[i]['orderID'],
                              snapshot.data[i]['id'],
                              snapshot.data[i]['uid'],
                              "${snapshot.data[i]['item1_name']}, ${snapshot.data[i]['item2_name']}, ${snapshot.data[i]['item3_name']}, ${snapshot.data[i]['item4_name']}",
                              snapshot.data[i]['address'],
                              snapshot.data[i]['contactNumber'],
                              snapshot.data[i]['totalBill'],
                              snapshot.data[i]['status'],
                              snapshot.data[i]['paymentScreenshot'],
                              snapshot.data[i]['totalItems'],
                              snapshot.data[i]['timestamp'],
                            );
                          if (orderCount == 0)
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text('No new order!',
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
      Size size,
      String orderId,
      String id,
      String uid,
      String name,
      String address,
      String contactNo,
      String totalBill,
      String status,
      String paymentScreenshot,
      int totalItems,
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
                      child: AutoSizeText('Address:',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, right: 10),
                          child: Text(address, maxLines: 2, style: kBodyText),
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
                      child: AutoSizeText('Contact:',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, right: 10),
                          child: Text(contactNo, maxLines: 2, style: kBodyText),
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
                          child: Text('Rs. $totalBill',
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
                      child: AutoSizeText('Payment Screenshot:',
                          maxLines: 2,
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    (paymentScreenshot == null)
                        ? Container(
                            child: Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5, right: 10),
                                child: Text('Waiting...',
                                    style: kBodyText.copyWith(color: kPrimary)),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => Get.to(() =>
                                ShowFullScreenImage(image: paymentScreenshot)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, top: 3.0),
                              child: Container(
                                  height: 25,
                                  width: 40,
                                  color: kWhite,
                                  child: Icon(Icons.image,
                                      size: 30, color: Colors.green)),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text(
                            'Do you want to mark this order as Confirmed?'),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: new Text('No',
                                style: TextStyle(color: Colors.red)),
                          ),
                          new TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimary))),
                              );

                              FirebaseFirestore.instance
                                  .collection('confirmedOrders')
                                  .doc(id)
                                  .set({
                                "id": id,
                                "uid": uid,
                                "items": name,
                                "orderID": orderId,
                                "totalBill": totalBill,
                                "contactNumber": contactNo,
                                "address": address,
                                "totalItems": totalItems,
                                "status": 'Confirmed',
                                "paymentScreenshot": paymentScreenshot,
                                "timestamp": date,
                              }).then((_) {
                                FirebaseFirestore.instance
                                    .collection('myOrders')
                                    .doc('orders')
                                    .collection(uid)
                                    .doc(id)
                                    .update({
                                  "status":
                                      "Order Confirmed, will be delivered soon.",
                                });

                                FirebaseFirestore.instance
                                    .collection('pendingOrders')
                                    .doc(id)
                                    .delete();
                                Get.offAll(() => AdminHomepage());
                                setState(() {});
                                Get.snackbar(
                                  '',
                                  "Order is marked as confirmed",
                                  titleText: Text('Order Confirmed',
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            },
                            child: new Text('Yes',
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Mark as Confirmed',
                          style: kBodyText.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 24)),
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
