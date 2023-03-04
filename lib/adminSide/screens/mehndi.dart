import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class Mehndi extends StatefulWidget {
  Mehndi({Key key}) : super(key: key);

  @override
  _MehndiState createState() => _MehndiState();
}

class _MehndiState extends State<Mehndi> {
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
        title: Text('Mehndi',
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
                        (snapshot.data[i]['event'] == 'mehndi')
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
            Get.to(() => AddMehndiMenu());
          },
          child: Icon(Icons.add, color: kBlack, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget serviceCard(Size size, String id, String serviceName, double rate) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.16,
      secondaryActions: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() =>
                      UpdateMenu(menuName: serviceName, rate: rate, id: id))
                  .then((value) {
                setState(() {});
              });
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: Icon(
                FontAwesomeIcons.pen,
                color: kWhite,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to delete $serviceName?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text('No', style: TextStyle(color: kBlack)),
                    ),
                    new TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('eventManagement')
                            .doc(id)
                            .delete()
                            .catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pop();
                        setState(() {});
                        Get.snackbar(
                          '',
                          "$serviceName is deleted from database",
                          titleText: Text('Menu Deleted!',
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
                      child:
                          new Text('Yes', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.trash,
                color: kWhite,
              ),
            ),
          ),
        )
      ],
      child: GestureDetector(
        onTap: () {
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
                border: Border.all(color: kPrimary),
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
                  child: AutoSizeText(
                      "$serviceName - ${rate.toInt()} per person",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: kBodyText.copyWith(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
