import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class UpdateCateringServices extends StatefulWidget {
  final String id;
  final String image;
  final String itemName;
  final double rate;
  UpdateCateringServices({
    Key key,
    this.id,
    this.itemName,
    this.rate,
    this.image,
  }) : super(key: key);

  @override
  _UpdateCateringServicesState createState() => _UpdateCateringServicesState();
}

class _UpdateCateringServicesState extends State<UpdateCateringServices> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rate = new TextEditingController();
  double totalAmount = 0;
  String image;

  File _image;
  final picker = ImagePicker();
  bool fileUploaded = false;

  getItemDetails() {
    setState(() {
      image = widget.image;
      _rate.text = widget.rate.toString();
    });
  }

  getImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      uploadImageToFirebase();
    } else {
      Get.snackbar(
        '',
        "Please select an image and try again",
        titleText: Text('No Image Selected',
            style: TextStyle(
                color: kPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
        duration: Duration(seconds: 4),
        backgroundColor: kWhite,
        colorText: kBlack,
        borderRadius: 10,
      );
    }
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(Uuid().v4());
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      String url = await firebaseStorageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection("cateringServices")
          .doc(widget.id)
          .update({
        "image": url,
      }).then((_) {
        setState(() {
          image = url;
        });
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    getItemDetails();
    super.initState();
  }

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Update Catering Service',
              style: GoogleFonts.dosis(
                color: kPrimary,
                fontSize: 27,
              )),
          backgroundColor: kBg,
          elevation: 0,
          //back Button
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.width * 0.03),
              Text(widget.itemName,
                  style: kBodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.07)),
              SizedBox(height: size.width * 0.05),
              Column(
                children: [
                  Container(
                    height: size.height * 0.17,
                    width: size.height * 0.17,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(image))),
                  ),
                  GestureDetector(
                    onTap: () => getImage(context),
                    child: Container(
                      height: 40,
                      width: size.height * 0.17,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(color: kPrimary, width: 2)),
                      child: Center(child: Text('Update Image')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.05),
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Rate
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: TextFormField(
                            controller: _rate,
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
                              labelText: 'Rate',
                              labelStyle:
                                  TextStyle(color: kPrimary, fontSize: 18),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: 'Enter Rate',
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
                              if (val.isEmpty) return 'Please enter rate';

                              return null;
                            }),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                      await FirebaseFirestore.instance
                          .collection('cateringServices')
                          .doc(widget.id)
                          .update({
                        "rate": double.parse(_rate.text),
                      }).then((_) async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        setState(() {});
                        Get.snackbar(
                          '',
                          "${widget.itemName} successfully updated",
                          titleText: Text('Successfully Updated',
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(onError.toString())));
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
                        'Update Item',
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
      ),
    );
  }
}
