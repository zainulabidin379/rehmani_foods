import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/adminSide/shared/shared.dart';

class UserFeedbacks extends StatefulWidget {
  const UserFeedbacks({Key key}) : super(key: key);

  @override
  _UserFeedbacksState createState() => _UserFeedbacksState();
}

class _UserFeedbacksState extends State<UserFeedbacks> {
  Future getEvents() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('contactUs')
        .orderBy('timestamp', descending: true)
        .get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Feedbacks',
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
          FutureBuilder<dynamic>(
              future: getEvents(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimary)));
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        feedbackCard(
                          size,
                          snapshot.data[i]['name'],
                          snapshot.data[i]['email'],
                          snapshot.data[i]['message'],
                          snapshot.data[i]['timestamp'],
                        ),
                    ],
                  );
                }
              }),
        ]),
      ),
    );
  }

  Widget feedbackCard(
      Size size, String name, String email, String message, Timestamp date) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.95,
              decoration: BoxDecoration(
                  color: kBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  border: Border.all(width: 2, color: kPrimary),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Flexible(
                            child: Text(name,
                                style: kBodyText.copyWith(
                                    color: kBlack, fontSize: 21)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 6, right: 10),
                          child: Text('($email)',
                              style: kBodyText.copyWith(
                                  color: kGrey, fontSize: 15)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(message,
                        style:
                            kBodyText.copyWith(color: kPrimary, fontSize: 22)),
                    SizedBox(height: 10),
                    Text(
                        DateTimeFormat.format(date.toDate(),
                            format: DateTimeFormats.american),
                        maxLines: 2,
                        style: kBodyText.copyWith(fontSize: 13, color: kGrey)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                sendEmail(name, email);
              },
              child: Container(
                width: size.width * 0.95,
                decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(width: 2, color: kPrimary),
                    boxShadow: [
                      BoxShadow(
                        color: kBlack.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Reply',
                      style: kBodyText.copyWith(color: kBlack, fontSize: 25)),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendEmail(
    String name,
    String email,
  ) async {
    final Email emailComp = Email(
      body: 'Write reply here.',
      subject: 'Hey! $name, Response of your feedback from REHMANI FOODS',
      recipients: [email],
      isHTML: false,
    );

    await FlutterEmailSender.send(emailComp);
  }
}
