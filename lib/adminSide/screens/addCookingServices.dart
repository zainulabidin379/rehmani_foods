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

class AddCookingServices extends StatefulWidget {
  AddCookingServices({Key key}) : super(key: key);

  @override
  _AddCookingServicesState createState() => _AddCookingServicesState();
}

class _AddCookingServicesState extends State<AddCookingServices> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _minWeight = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _serving = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  double totalAmount = 0;
  String unit;
  bool isKg = false;
  bool isParat = false;
  String image;

  String type;
  bool isCooking = false;
  bool isCatering = false;

  File _image;
  final picker = ImagePicker();
  bool fileUploaded = false;

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
      setState(() {
        image = url;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _minWeight.dispose();
    _rate.dispose();
    _serving.dispose();
    _name.dispose();
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
          title: Text('Add Cooking Service',
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
              Column(
                children: [
                  (image == null)
                      ? SizedBox()
                      : Container(
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
                                  fit: BoxFit.cover,
                                  image: NetworkImage(image))),
                        ),
                  GestureDetector(
                    onTap: () => getImage(context),
                    child: Container(
                      height: 40,
                      width: size.height * 0.17,
                      decoration: BoxDecoration(
                          borderRadius: (image == null)
                              ? BorderRadius.circular(50)
                              : BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                          border: Border.all(color: kPrimary, width: 2)),
                      child: Center(child: Text('Choose Image')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.02),
              Form(
                key: _formKey,
                child: Column(children: [
                  //Item name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                        controller: _name,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        style: kBodyText,
                        cursorColor: kPrimary,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 30,
                            top: 15,
                            bottom: 15,
                          ),
                          labelText: 'Item Name',
                          labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Item Name',
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 19),
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
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter item name';

                          return null;
                        }),
                  ),

                  //Min Weight/quantity
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                        controller: _minWeight,
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
                          labelText: 'Minimum Weight/Quantity',
                          labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Minimum Weight/Quantity',
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 19),
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
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Please enter minimum weight/quantity';

                          return null;
                        }),
                  ),

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
                          labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Rate',
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 19),
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
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter rate';

                          return null;
                        }),
                  ),

                  //Serving
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: TextFormField(
                        controller: _serving,
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
                          labelText: 'Serving',
                          labelStyle: TextStyle(color: kPrimary, fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: ' Enter Serving per 5 Kg/Parat',
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 19),
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
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Please enter required weight/quantity';

                          return null;
                        }),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    child: Row(
                      children: [
                        Text('Unit: ',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            )),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isKg = true;
                              isParat = false;
                              unit = 'Kg';
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kPrimary, width: 2),
                                color: isKg ? kPrimary : Colors.transparent,
                              ),
                              child: Center(
                                  child: Text('Kg',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: kBlack,
                                      )))),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isParat = true;
                              isKg = false;
                              unit = 'Parat';
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kPrimary, width: 2),
                                color: isParat ? kPrimary : Colors.transparent,
                              ),
                              child: Center(
                                  child: Text('Parat',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: kBlack,
                                      )))),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    child: Row(
                      children: [
                        Text('Type: ',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            )),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCooking = true;
                              isCatering = false;
                              type = 'cooking';
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kPrimary, width: 2),
                                color:
                                    isCooking ? kPrimary : Colors.transparent,
                              ),
                              child: Center(
                                  child: Text('Cooking',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: kBlack,
                                      )))),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCatering = true;
                              isCooking = false;
                              type = 'catering';
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kPrimary, width: 2),
                                color:
                                    isCatering ? kPrimary : Colors.transparent,
                              ),
                              child: Center(
                                  child: Text('Catering',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: kBlack,
                                      )))),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (unit == null || type == null || image == null) {
                        Get.snackbar(
                          '',
                          "Please fill all details to add item.",
                          titleText: Text('Fill All Details',
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Center(
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(kPrimary))),
                        );
                        String id = Uuid().v1();
                        await FirebaseFirestore.instance
                            .collection('cookingServices')
                            .doc(id)
                            .set({
                          "id": id,
                          "image": image,
                          "serviceName": _name.text,
                          "minWeight": double.parse(_minWeight.text),
                          "rate": double.parse(_rate.text),
                          "serving": double.parse(_serving.text),
                          "unit": unit,
                          "type": type,
                        }).then((_) async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});
                          Get.snackbar(
                            '',
                            "${_name.text} successfully added to database",
                            titleText: Text('Successfully Added',
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
                        'Add Item',
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
