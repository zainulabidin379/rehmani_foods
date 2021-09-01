import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/shared.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('About Us',
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
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/aboutUs.jpg'),
                fit: BoxFit.cover,
              )),
            ),
            Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      aboutUsCard(size, '- Vision -',
                          'To build an outstanding reputation through our excellent and dedicated services'),
                          aboutUsCard(size, '- Mission -',
                          'Our mission is to provide outstanding services in the domain of catering, events, hospitality and tourism'),
                          aboutUsCard(size, '- Values -',
                          'We believe in honesty, highest quality and consistency for our customers'),
                    ],
                  ),
                )),
              ],
            )
          ],
        ));
  }

  Padding aboutUsCard(Size size, String title, String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height* 0.04,),
      child: Column(
        children: [
          Center(
            child: Text(title,
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.width * 0.1,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(detail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kWhite,
                    fontSize: size.width * 0.065,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
