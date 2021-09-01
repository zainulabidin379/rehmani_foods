import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/adminSide/screens/screens.dart';
import 'package:rehmani_foods/adminSide/shared/shared.dart';

class ViewInventory extends StatefulWidget {
  const ViewInventory({Key key}) : super(key: key);

  @override
  _ViewInventoryState createState() => _ViewInventoryState();
}

class _ViewInventoryState extends State<ViewInventory> {
  Future getInventory() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('inventory').get();

    return qn.docs;
  }

  bool swap = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inventory',
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
          SizedBox(height: 5),
          FutureBuilder<dynamic>(
              future: getInventory(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimary)));
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        inventoryItemCard(
                          size,
                          snapshot.data[i]['itemName'],
                          snapshot.data[i]['itemWeight'],
                          snapshot.data[i]['unit'],
                        ),
                    ],
                  );
                }
              }),
        ]),
      ),
    );
  }

  Widget inventoryItemCard(Size size, String name, String weight, String unit) {
    swap ? swap = false : swap = true;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.16,
      secondaryActions: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => UpdateInventory(itmeName: name, weight: weight,)).then((value) {
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
                  content: new Text('Do you want to delete this item?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text('No', style: TextStyle(color: kBlack)),
                    ),
                    new TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('inventory')
                            .doc(name)
                            .delete()
                            .catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pop();
                        setState(() {});
                        Get.snackbar(
                          '',
                          "Item is deleted from inventory",
                          titleText: Text('Item Deleted!',
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
              height: 60,
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
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
        child: Center(
          child: Container(
            height: 60,
            width: size.width * 0.95,
            decoration: BoxDecoration(
                color: swap ? kWhite : kPrimary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: swap ? kPrimary : kWhite),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                    ),
                  ),
                  Text(
                    '$weight $unit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: swap ? kPrimary : kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
