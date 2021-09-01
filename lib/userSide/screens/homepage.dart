import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehmani_foods/userSide/services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthService _auth = AuthService();
  String name;
  String email;
  Future getUser() async {
    var currentUser = _auth.getCurrentUser();
    var firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(currentUser).get().then((value) {
      setState(() {
        name = value['name'];
        email = value['email'];
      });
    });
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No', style: TextStyle(color: kPrimary)),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes', style: TextStyle(color: kBlack)),
              ),
            ],
          ),
        ))) ??
        false;
  }

  int cartItemsCount = 0;
  Future getCartItems() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('cart').doc('carts').collection(uid).get();
    setState(() {
      cartItemsCount = qn.docs.length;
    });
  }

  Future getFeaturedItems() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('featuredItems').get();

    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    getCartItems();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Rehmani Foods',
              style: GoogleFonts.courgette(
                color: kPrimary,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: kBg,
          elevation: 0,
          //Menu Button
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Icon(Icons.menu_rounded, color: kBlack, size: 40),
              ),
            ),
          ),
          //cart Icon
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                Get.to(() => Cart()).then((_) {
                  setState(() {
                    getCartItems();
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Icon(
                        FontAwesomeIcons.shoppingCart,
                        size: 27,
                        color: kBlack,
                      ),
                    )),
                    Positioned(
                      top: 7,
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Text(cartItemsCount.toString(),
                                style: TextStyle(fontSize: 16))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: NavDrawer(
          name: name,
          email: email,
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Text('Welcome',
                  style: TextStyle(color: kBlack, fontSize: 29)),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('Featured Items',
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: 13),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<dynamic>(
                  future: getFeaturedItems(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: size.height * 0.18,
                        width: size.width,
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(kPrimary))),
                      );
                    } else {
                      return Row(
                        children: [
                          for (var i = 0; i < snapshot.data.length; i++)
                            featuredItemCard(
                              size,
                              snapshot.data[i]['id'],
                              snapshot.data[i]['image'],
                              snapshot.data[i]['serviceName'],
                              snapshot.data[i]['rate'].toDouble(),
                              snapshot.data[i]['minWeight'].toDouble(),
                              snapshot.data[i]['unit'],
                              snapshot.data[i]['serving'].toDouble(),
                              snapshot.data[i]['type'],
                            ),
                        ],
                      );
                    }
                  }),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('Our Services',
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: 13),
            servicesCard(size, () {
              Get.to(() => CookingOrder()).then((_) {
                setState(() {
                  getCartItems();
                });
              });
            }, 'Cooking Services', 'cooking.jpg'),
            servicesCard(size, () {
              Get.to(() => CateringOrder()).then((_) {
                setState(() {
                  getCartItems();
                });
              });
            }, 'Catering Services', 'catering.jpg'),
            servicesCard(size, () {
              Get.to(() => EventManagement()).then((_) {
                setState(() {
                  getCartItems();
                });
              });
            }, 'Event Management', 'eventManagement.jpg')
          ]),
        ),
      ),
    );
  }

  Widget servicesCard(Size size, Function onTap, String service, String image) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Center(
          child: Column(
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/$image")),
                  color: kWhite,
                ),
              ),
              Container(
                height: 50,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.zero,
                    topLeft: Radius.zero,
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    service,
                    style: kBodyText.copyWith(
                        fontSize: 25,
                        color: kWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featuredItemCard(
    Size size,
    String id,
    String image,
    String serviceName,
    double rate,
    double minWeight,
    String unit,
    double serving,
    String type,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetails(
              id: id,
              type: type,
              itemName: serviceName,
              rate: rate,
              minWeight: minWeight,
              unit: unit,
              serving: serving,
              image: image,
            )).then((_) {
          setState(() {
            getCartItems();
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              height: size.height * 0.15,
              width: size.width * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(image)),
                color: kWhite,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(serviceName, style: kBodyText.copyWith(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
