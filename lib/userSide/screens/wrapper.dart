import 'package:rehmani_foods/adminSide/screens/adminHomepage.dart';
import 'screens.dart';
import '../shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.hasData && snapshot.data != ConnectivityResult.none) {
            if (user == null) {
              return SignIn();
            } else {
              if (user.uid == 'LPaU7e29P5QAj6YUH8zLTRkfMQ62' ||
                  user.uid == '7Lgs69T0Ebcm2pTTpueetVCsT6h1') {
                return AdminHomepage();
              } else {
                return Homepage();
              }
            }
          } else {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        width: size.width * 0.3,
                        child: Image.asset('assets/icons/internet.png')),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Center(
                      child: Text(
                    'Looks like you are Offline!',
                    style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: size.height * 0.01),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Please check your internet connection and try again. ",
                      style: TextStyle(fontSize: size.width * 0.04),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),
            );
          }
        });
  }
}
