import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class AddInventoryItem extends StatefulWidget {
  AddInventoryItem({Key key}) : super(key: key);

  @override
  _AddInventoryItemState createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _item = new TextEditingController();
  TextEditingController _weight = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _item.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Item to Inventory',
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
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.width * 0.05),
                Text('Enter item details',
                    textAlign: TextAlign.center,
                    style: kBodyText.copyWith(fontSize: size.width * 0.06)),
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
                              controller: _item,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: kBodyText,
                              cursorColor: kPrimary,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 30,
                                  top: 15,
                                  bottom: 15,
                                ),
                                labelText: 'Item Name',
                                labelStyle:
                                    TextStyle(color: kPrimary, fontSize: 18),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter item name',
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
                                  return 'Please enter item name';

                                if (val.length < 3) {
                                  return 'Please enter valid item name';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20),
                          child: TextFormField(
                              controller: _weight,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: kBodyText,
                              cursorColor: kPrimary,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 30,
                                  top: 15,
                                  bottom: 15,
                                ),
                                labelText: 'Item Weight',
                                labelStyle:
                                    TextStyle(color: kPrimary, fontSize: 18),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter item weight in Kg',
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
                                  return 'Please enter item weight in Kg';

                                return null;
                              }),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Center(
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(kPrimary))),
                        );

                        var collectionRef = await FirebaseFirestore.instance
                            .collection('inventory')
                            .doc(_item.text)
                            .get();
                        if (collectionRef.exists) {
                          Navigator.pop(context);
                          Get.snackbar(
                            '',
                            "This item already exists in inventory",
                            titleText: Text('Item Already Exist!',
                                style: TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            duration: Duration(seconds: 4),
                            backgroundColor: kWhite,
                            colorText: kBlack,
                            borderRadius: 10,
                          );
                        } else {
                          FirebaseFirestore.instance
                              .collection('inventory')
                              .doc(_item.text)
                              .set({
                            "itemName": _item.text,
                            "itemWeight": _weight.text,
                            "unit": 'Kg',
                            "timestamp": DateTime.now(),
                          }).then((_) async {
                          Navigator.pop(context);
                          Navigator.pop(context); 
                            Get.snackbar(
                              '',
                              "Item is successfully added in inventory",
                              titleText: Text('Item Added',
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(onError)));
                          });
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
                          'Add To Inventory',
                          style: kBodyText.copyWith(
                              fontWeight: FontWeight.bold, color: kWhite),
                        ),
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
