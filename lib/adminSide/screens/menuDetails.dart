import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/adminSide/screens/screens.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class MenuDetails extends StatefulWidget {
  final String id;
  final String name;
  final double rate;
  MenuDetails({Key key, this.id, this.name, this.rate}) : super(key: key);

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  Future getMenus() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('eventManagement')
        .doc(widget.id)
        .collection('menuItems')
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
        title: Text('Menu Details',
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
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: getMenus(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimary)));
                  } else {
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: AutoSizeText('${widget.name} Includes',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: kBodyText.copyWith(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        for (var i = 0; i < snapshot.data.length; i++)
                          menuCard(
                            size,
                            snapshot.data[i]['id'],
                            snapshot.data[i]['image'],
                            snapshot.data[i]['itemName'],
                            widget.rate,
                          ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 15),
        child: FloatingActionButton(
          backgroundColor: kPrimary,
          foregroundColor: Colors.black,
          onPressed: () {
            Get.to(() => AddMenuItem(id: widget.id));
          },
          child: Icon(Icons.add, color: kBlack, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget menuCard(
      Size size, String id, String image, String serviceName, double rate) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.16,
        secondaryActions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: GestureDetector(
              onTap: () => Get.to(() => UpdateMenuItem(
                    id: id,
                    pid: widget.id,
                    image: image,
                    name: serviceName,
                  )).then((value) {
                setState(() {});
              }),
              child: Container(
                height: 70,
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
                              .doc(widget.id)
                              .collection('menuItems')
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
                        child: new Text('Yes',
                            style: TextStyle(color: Colors.red)),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 70,
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
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: AutoSizeText(serviceName,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: kBodyText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ));
  }
}
