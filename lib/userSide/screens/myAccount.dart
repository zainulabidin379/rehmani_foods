import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final AuthService _auth = AuthService();
  bool isEditing = false;

  final _name = TextEditingController();
  final _email = TextEditingController();

  String name;
  String email;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Account',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    controller: _name,
                    enabled: isEditing,
                    cursorColor: kPrimary,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 30),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: name,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    controller: _email,
                    enabled: false,
                    cursorColor: kPrimary,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 30),
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: email,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: kPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                isEditing ? saveButtonRow() : editInfoButton()
              ],
            ),
          ),
        ));
  }

  Padding editInfoButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: kPrimary,
          ),
          child: Center(
            child: Text(
              'Change Your Name',
              style: kBodyText.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Row saveButtonRow() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5.0, top: 20.0),
          child: InkWell(
            onTap: () {
              setState(() {
                isEditing = false;
                _name.text = name;
              });
            },
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                decoration: BoxDecoration(
                    color: kGrey, borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Cancel',
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                )),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 20.0, top: 20.0),
          child: InkWell(
            onTap: () async {
              setState(() {
                isEditing = false;
                if (_name.text == '') {
                  _name.text = name;
                }
              });
              await DatabaseService(uid: _auth.getCurrentUser()).updateUserData(
                _name.text,
              );

              Get.snackbar(
                '',
                "Congratulations! Your name is changed",
                titleText: Text('Name Changed',
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
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                decoration: BoxDecoration(
                    color: kPrimary, borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Change',
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                )),
          ),
        )),
      ],
    );
  }

  fetchData() async {
    var currentUser = _auth.getCurrentUser();
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();

    setState(() {
      name = variable['name'];
      email = variable['email'];
    });
  }
}
