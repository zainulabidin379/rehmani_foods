import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/shared.dart';
import 'screens.dart';

class Inventory extends StatefulWidget {
  Inventory({Key key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
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
          SizedBox(height: 8),
          addInventoryItemButton(size, 'Add Item To Inventory'),
          viewInventoryButton(size, 'View Inventory'),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget addInventoryItemButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddInventoryItem()).then((value) {
          setState(() {});
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
        child: Center(
          child: Container(
            height: 60,
            width: size.width * 0.95,
            decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: kPrimary),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                  child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget viewInventoryButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewInventory());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
        child: Center(
          child: Container(
            height: 60,
            width: size.width * 0.95,
            decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: kPrimary),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                  child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
