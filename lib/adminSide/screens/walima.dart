import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class Walima extends StatefulWidget {
  Walima({Key key}) : super(key: key);

  @override
  _WalimaState createState() => _WalimaState();
}

class _WalimaState extends State<Walima> {
  Future getServices() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('eventManagement').get();

    return qn.docs;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Barat/Walima',
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
                        (snapshot.data[i]['event'] == 'walima')
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 15),
        child: FloatingActionButton(
          backgroundColor: kPrimary,
          foregroundColor: Colors.black,
          onPressed: () {
            Get.to(() => AddWalimaMenu());
          },
          child: Icon(Icons.add, color: kBlack, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            ));
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
