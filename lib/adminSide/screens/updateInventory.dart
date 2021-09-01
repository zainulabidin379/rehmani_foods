import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class UpdateInventory extends StatefulWidget {
  final String itmeName;
  final String weight;
  UpdateInventory({Key key, this.itmeName, this.weight}) : super(key: key);

  @override
  _UpdateInventoryState createState() => _UpdateInventoryState();
}

class _UpdateInventoryState extends State<UpdateInventory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _weight = new TextEditingController();

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  updateInventoryItem() {
    setState(() {
      _weight.text = widget.weight;
    });
  }

  @override
  void initState() {
    super.initState();
    updateInventoryItem();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update Inventory Item',
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
                Text(widget.itmeName,
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

                        FirebaseFirestore.instance
                            .collection('inventory')
                            .doc(widget.itmeName)
                            .update({
                          "itemWeight": _weight.text,
                          "timestamp": DateTime.now(),
                        }).then((_) async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Get.snackbar(
                            '',
                            "Item is successfully updated in inventory",
                            titleText: Text('Item Updated',
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
                          'Update Item',
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
