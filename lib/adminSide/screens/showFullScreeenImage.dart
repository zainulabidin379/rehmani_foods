import 'package:flutter/material.dart';
import '../shared/shared.dart';

class ShowFullScreenImage extends StatefulWidget {
  final String image;
  ShowFullScreenImage({Key key, this.image}) : super(key: key);

  @override
  _ShowFullScreenImageState createState() => _ShowFullScreenImageState();
}

class _ShowFullScreenImageState extends State<ShowFullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        //Back Button
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 2,
          child: Image.network(
            widget.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget imageCard(Size size, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Container(
        height: 230,
        width: size.width,
        decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kPrimary, width: 2),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ]),
      ),
    );
  }
}
