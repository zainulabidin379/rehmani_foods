import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/screens/screens.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';

class AdminSettings extends StatefulWidget {
  AdminSettings({Key key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin Settings',
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
          resetPasswordButton(size, 'Change Password'),
          signOutButton(size, 'Sign Out'),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  //Reset password button
  Widget resetPasswordButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> ChangePassword());
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

  Widget signOutButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to sign out?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('No', style: TextStyle(color: kBlack)),
              ),
              new TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  Get.offAll(() => SignIn());
                  Get.snackbar(
                    '',
                    "Admin signed out successfully",
                    titleText: Text('Signed Out',
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
                child: new Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
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
