import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

class AddEmployee extends StatefulWidget {
  AddEmployee({Key key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();

  String type;
  bool isChef = false;
  bool isCoAdmin = false;
  bool isBbqBoy = false;
  bool isHelper = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Employee',
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
                Text('Enter Employee details',
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
                                labelText: 'Name',
                                labelStyle:
                                    TextStyle(color: kPrimary, fontSize: 18),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter employee name',
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
                                  return 'Please enter employee name';

                                if (val.length < 3) {
                                  return 'Please enter valid employee name';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 20),
                          child: Row(
                            children: [
                              Text('Type: ',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack,
                                  )),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChef = false;
                                            isHelper = false;
                                            isCoAdmin = true;
                                            isBbqBoy = false;
                                            type = 'Co-Admin';
                                          });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: size.width*0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kPrimary, width: 2),
                                              color: isCoAdmin
                                                  ? kPrimary
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('Co-Admin',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kBlack,
                                                    )))),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChef = true;
                                            isHelper = false;
                                            isCoAdmin = false;
                                            isBbqBoy = false;
                                            type = 'Chef';
                                          });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: size.width*0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kPrimary, width: 2),
                                              color: isChef
                                                  ? kPrimary
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('Chef',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kBlack,
                                                    )))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChef = false;
                                            isHelper = true;
                                            isCoAdmin = false;
                                            isBbqBoy = false;
                                            type = 'Helper';
                                          });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: size.width*0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kPrimary, width: 2),
                                              color: isHelper
                                                  ? kPrimary
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('Helper',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kBlack,
                                                    )))),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChef = false;
                                            isHelper = false;
                                            isCoAdmin = false;
                                            isBbqBoy = true;
                                            type = 'BBQ Boy';
                                          });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: size.width*0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kPrimary, width: 2),
                                              color: isBbqBoy
                                                  ? kPrimary
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('BBQ Boy',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kBlack,
                                                    )))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                            .collection('employees')
                            .doc('${_name.text} ($type)')
                            .get();
                        if (collectionRef.exists) {
                          Navigator.pop(context);
                          Get.snackbar(
                            '',
                            "This employee already exists in database",
                            titleText: Text('Employee Already Exist!',
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
                              .collection('employees')
                              .doc('${_name.text} ($type)')
                              .set({
                            "employeeName": _name.text,
                            "type": type,
                            "timestamp": DateTime.now(),
                          }).then((_) async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Get.snackbar(
                              '',
                              "Employee is successfully added in database",
                              titleText: Text('Employee Added',
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
                          'Add Employee',
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
