import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';
import 'package:uuid/uuid.dart';

class AddWalimaMenu extends StatefulWidget {
  AddWalimaMenu({Key key}) : super(key: key);

  @override
  _AddWalimaMenuState createState() => _AddWalimaMenuState();
}

class _AddWalimaMenuState extends State<AddWalimaMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _rate = new TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Walima Menu',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.width * 0.05),
            Text('Enter Menu Details',
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
                          controller: _name,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: kBodyText,
                          cursorColor: kPrimary,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 30,
                              top: 15,
                              bottom: 15,
                            ),
                            labelText: 'Menu Name',
                            labelStyle:
                                TextStyle(color: kPrimary, fontSize: 18),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                            hintText: 'Enter menu name',
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
                              return 'Please enter menu name';

                            if (val.length < 3) {
                              return 'Please enter valid menu name';
                            }
                            return null;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: TextFormField(
                          controller: _rate,
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
                            labelText: 'Rate per person',
                            labelStyle:
                                TextStyle(color: kPrimary, fontSize: 18),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                            hintText: 'Enter menu rate',
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
                              return 'Please enter menu rate';
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

                    String id = Uuid().v4();
                    FirebaseFirestore.instance
                        .collection('eventManagement')
                        .doc(id)
                        .set({
                      "menu": _name.text,
                      "id": id,
                      "rate": double.parse(_rate.text),
                      "event": 'walima',
                    }).then((_) async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Get.snackbar(
                        '',
                        "Menu is successfully added in database",
                        titleText: Text('Menu Added',
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
                      'Add Menu',
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
    );
  }
}
