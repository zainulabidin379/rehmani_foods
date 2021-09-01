import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/shared.dart';

class Users extends StatefulWidget {
  Users({Key key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future getUsers() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('users').orderBy('timestamp').get();

    return qn.docs;
  }

  int users = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Users',
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
          FutureBuilder<dynamic>(
              future: getUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimary)));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        usersCard(
                          size,
                          snapshot.data[i]['name'],
                          snapshot.data[i]['email'],
                          snapshot.data[i]['timestamp'],
                        ),
                      (users == 0)
                          ? noUsers(size, 'No Users here!')
                          : SizedBox(),
                    ],
                  );
                }
              }),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  //No Users
  Widget noUsers(Size size, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Center(
        child: Container(
          height: 60,
          width: size.width * 0.95,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kPrimary, width: 2),
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
    );
  }

  Widget usersCard(Size size, String name, String email, Timestamp date) {
    users++;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Center(
        child: Column(
          children: [
            Container(
              width: size.width * 0.95,
              decoration: BoxDecoration(
                  color: kBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: kPrimary),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Text(name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: kBodyText.copyWith(
                            color: kPrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text('Email: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(email,
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text('Date: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                              DateTimeFormat.format(date.toDate(),
                                  format: DateTimeFormats.american),
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
