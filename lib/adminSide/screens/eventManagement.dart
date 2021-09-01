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
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 5),
          eventsCard(size, () {
            Get.to(() => Mehndi());
          }, 'Mehndi', 'mehndi.jpg'),
          SizedBox(height: 5),
          eventsCard(size, () {
            Get.to(() => Walima());
          }, 'Barat/Walima', 'walima.jpg'),
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
