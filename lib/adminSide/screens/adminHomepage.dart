import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/shared.dart';
import 'screens.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No', style: TextStyle(color: kPrimary)),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes', style: TextStyle(color: kBlack)),
              ),
            ],
          ),
        ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Admin Panel',
              style: GoogleFonts.dosis(
                color: kPrimary,
                fontSize: 27,
              )),
          backgroundColor: kBg,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //1ST ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => PendingOrders())
                        },
                    'Pending Orders'),
                    
                menuCard(
                    size,
                    () => {
                          Get.to(() => ConfirmedOrders())
                        },
                    'Confirmed Orders'),
              ],
            ),
            //2nd ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => CompletedOrders())
                        },
                    'Completed Orders'),
                menuCard(
                    size,
                    () => {
                          Get.to(() => Inventory()),
                        },
                    'Inventory'),
              ],
            ),
            //3rd ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => Employees())
                        },
                    'Employees'),
                menuCard(
                    size,
                    () => {
                          Get.to(() => UserFeedbacks()),
                        },
                    'User Feedbacks'),
              ],
            ),
            //4th ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => FeaturedItems()),
                        },
                    'Featured Items'),
                menuCard(
                    size,
                    () => {
                          Get.to(() => CookingServices())
                        },
                    'Cooking Services'),
              ],
            ),
            //5th ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => CateringServices())
                        },
                    'Catering Services'),
                menuCard(
                    size,
                    () => {
                          Get.to(() => EventManagement())
                        },
                    'Event Management'),
              ],
            ),

            //6th ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuCard(
                    size,
                    () => {
                          Get.to(() => Users()),
                        },
                    'Users'),
                menuCard(
                    size,
                    () => {
                          Get.to(() => AdminSettings()).then((_) {}),
                        },
                    'Admin Settings'),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget menuCard(Size size, Function onTap, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: GestureDetector(
        onTap: onTap as void Function(),
        child: Container(
          height: size.width * 0.4,
          width: size.width * 0.4,
          decoration: BoxDecoration(
              color: kBg,
              border: Border.all(color: kPrimary),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(name,
                  textAlign: TextAlign.center,
                  style: kBodyText.copyWith(
                      color: kBlack, fontSize: size.width * 0.05)),
            ),
          ),
        ),
      ),
    );
  }
}
