import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rehmani_foods/userSide/screens/screens.dart';
import 'package:rehmani_foods/userSide/services/services.dart';
import 'package:rehmani_foods/userSide/shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp ();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<TheUser>.value(
      value: AuthService().user,
      initialData: null,
          child: GetMaterialApp(
        title: 'Rehmani Foods',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme:
                GoogleFonts.dosisTextTheme(Theme.of(context).textTheme),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        home: Wrapper(),
      ),
    );
  }
}
