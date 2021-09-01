import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';
import 'screens.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contact Us',
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
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                'For all enquiries, please contact us using the form below. We will get back to you as soon as possible.',
                style: kBodyText.copyWith(color: kBlack),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                      controller: _name,
                      style: kBodyText.copyWith(color: kBlack),
                      cursorColor: kBlack,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Your Name',
                        hintStyle:
                            kBodyText.copyWith(fontSize: 20, color: kBlack),
                        prefixIcon: Icon(
                          FontAwesomeIcons.userAlt,
                          color: kPrimary,
                          size: 20,
                        ),
                        errorStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                      ),
                      validator: FieldValidator.minLength(3,
                          message: 'Enter a valid name'),
                    ),
                  ),

                  //Email
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                      controller: _email,
                      style: kBodyText.copyWith(color: kBlack),
                      cursorColor: kBlack,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Your Email',
                        hintStyle:
                            kBodyText.copyWith(fontSize: 20, color: kBlack),
                        prefixIcon: Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: kPrimary,
                          size: 20,
                        ),
                        errorStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                      ),
                      validator: FieldValidator.email(),
                    ),
                  ),

                  //Phone
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                      controller: _message,
                      style: kBodyText.copyWith(color: kBlack),
                      cursorColor: kBlack,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        hintText: 'Your Message',
                        hintStyle:
                            kBodyText.copyWith(fontSize: 20, color: kBlack),
                        prefixIcon: Icon(
                          FontAwesomeIcons.solidComments,
                          color: kPrimary,
                          size: 20,
                        ),
                        errorStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: kPrimary, width: 1.5),
                        ),
                      ),
                      validator: FieldValidator.minLength(1,
                          message: 'Please enter your message'),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimary))),
                          );

                          String id = Uuid().v4();
                          FirebaseFirestore.instance
                              .collection('contactUs')
                              .doc(id)
                              .set({
                            "id": id,
                            "uid": FirebaseAuth.instance.currentUser.uid,
                            "name": _name.text,
                            "email": _email.text,
                            "message": _message.text,
                            "timestamp": DateTime.now(),
                          }).then((value) {
                            Get.offAll(() => Homepage());
                            Get.snackbar(
                              '',
                              "Your message has been sent, team will get back to you ASAP.",
                              titleText: Text('Message Sent',
                                  style: TextStyle(
                                      color: kPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              duration: Duration(seconds: 4),
                              backgroundColor: kWhite,
                              colorText: kBlack,
                              borderRadius: 10,
                            );
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        height: 50,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: kPrimary,
                        ),
                        child: Center(
                          child: Text(
                            'Send',
                            style:
                                kBodyText.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Or',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      launch("tel:03001234567");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                      height: 50,
                      width: size.width * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Icon(FontAwesomeIcons.phone, color: kWhite)),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      launch('mailto:rehmanifoods4@gmail.com');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                      height: 50,
                      width: size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: Color(0xFFFD44638)),
                      child: Center(
                          child: Icon(FontAwesomeIcons.envelope, color: kWhite)),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      launch('https://www.facebook.com/pages/category/Food-Delivery-Service/Rehmani-Foods-Cooking-Catering-100357075148523/');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                      height: 50,
                      width: size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: Color(0xFFF4267B2)),
                      child: Center(
                          child: Icon(FontAwesomeIcons.facebook, color: kWhite)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
