import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehmani_foods/userSide/services/services.dart';
import '../screens/screens.dart';
import 'package:the_validator/the_validator.dart';
import '../shared/shared.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool loading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
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
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimary)))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 30.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: size.width * 0.85,
                        ),
                      ),
                    ),
                    //Heading
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.width * 0.03),
                      child: Text(
                        'Sign Up',
                        style: kBodyText.copyWith(
                            fontSize: size.width * 0.1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 19),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: kPrimary,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimary),
                                  ),
                                ),
                                validator: FieldValidator.multiple([
                                  FieldValidator.required(
                                      message: 'Please enter your name'),
                                  FieldValidator.minLength(3,
                                      message: 'Please enter a valid name')
                                ]),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              child: TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: kBodyText,
                                cursorColor: kPrimary,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 19),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 30,
                                    color: kPrimary,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimary),
                                  ),
                                ),
                                validator: FieldValidator.multiple([
                                  FieldValidator.required(
                                      message: 'Please enter your email'),
                                  FieldValidator.email(),
                                ]),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              child: TextFormField(
                                controller: _password,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                style: kBodyText,
                                obscureText: _obscurePassword,
                                cursorColor: kPrimary,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 19),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 30,
                                    color: kPrimary,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimary),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: FieldValidator.multiple([
                                  FieldValidator.required(
                                      message: 'Please enter your password'),
                                  FieldValidator.password(
                                      errorMessage:
                                          'Password must be atleast 6 characters',
                                      minLength: 6),
                                ]),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              child: TextFormField(
                                  controller: _confirmPassword,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: kBodyText,
                                  obscureText: _obscureConfirmPassword,
                                  cursorColor: kPrimary,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 19),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: 30,
                                      color: kPrimary,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: kPrimary),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _obscureConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'This field is required';
                                    if (val != _password.text)
                                      return 'Password must be same';
                                    if (val.length < 6) {
                                      return 'Password must be same';
                                    }
                                    return null;
                                  }),
                            ),

                            SizedBox(
                              height: 25,
                            ),
                            //SignUp Button
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });

                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            _name.text,
                                            _email.text,
                                            _password.text);

                                    if (result == null) {
                                      if (_auth.getCurrentUser() ==
                                              'SUj5uhm9jDX3EqRVW5uxDu5rWph1' ||
                                          _auth.getCurrentUser() ==
                                              '7Lgs69T0Ebcm2pTTpueetVCsT6h1') {
                                        //Get.offAll(() => AdminHomeScreen());
                                      } else {
                                        Get.offAll(() => Homepage());
                                      }
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });

                                      Get.snackbar(
                                        'Error',
                                        result,
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        colorText: kWhite,
                                        borderRadius: 10,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  height: 50,
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: kPrimary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: kBodyText.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //Widget to navigate to register screen
                            Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20, top: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => SignIn());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: kBodyText,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Sign In",
                                        style: kBodyText.copyWith(
                                            color: kPrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                          ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
