import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../screens/screens.dart';
import '../services/services.dart';

import 'constants.dart';

class NavDrawer extends StatefulWidget {
  final String name;
  final String email;

  const NavDrawer({Key key, this.name, this.email}) : super(key: key);
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final AuthService _auth = AuthService();
  Future getUser() async {
    var currentUser = _auth.getCurrentUser();
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(currentUser).get();

    // setState(() {
    //   isActivated = snapshot.data['isVerified'];
    // });
    return snapshot;
  }

  bool isActivated = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey There!',
                  style: kBodyText.copyWith(
                      fontSize: size.width * 0.07, color: kBlack),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  "${widget.name}",
                  style: kBodyText.copyWith(
                      fontSize: size.width * 0.09,
                      color: kPrimary,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, right: 7),
                      child: Icon(
                        FontAwesomeIcons.solidEnvelope,
                        size: size.width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    Text(widget.email,
                        style: kBodyText.copyWith(
                            fontSize: size.width * 0.05, color: Colors.grey)),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: kBg,
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.home,
              color: kPrimary,
              size: 25,
            ),
            title: Text('Home',
                style: kBodyText.copyWith(
                    fontWeight: FontWeight.bold, color: kPrimary)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.fileInvoice,
              color: kPrimary,
              size: 25,
            ),
            title: Text('My Orders', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {Get.to(() => MyOrders())},
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.userAlt,
              color: kPrimary,
              size: 25,
            ),
            title: Text('My Account', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {
              Get.to(()=> MyAccount())
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.users,
              color: kPrimary,
              size: 25,
            ),
            title: Text('About Us', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {
              Get.to(() => AboutUs()),
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.headset,
              color: kPrimary,
              size: 25,
            ),
            title: Text('Contact Us', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {
              Get.to(() => ContactUs()),
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: kPrimary,
              size: 25,
            ),
            title: Text('Logout', style: kBodyText.copyWith(color: kBlack)),
            onTap: () async {
              await _auth.signOut();
              Get.to(() => SignIn());
              Get.snackbar('Signed Out!', 'Signed Out Successfully',
                  duration: Duration(seconds: 3),
                  backgroundColor: kPrimary,
                  colorText: kWhite,
                  borderWidth: 2,
                  borderRadius: 50);
            },
          ),
        ],
      ),
    );
  }
}
