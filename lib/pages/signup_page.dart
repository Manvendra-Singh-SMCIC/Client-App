// ignore_for_file: prefer_const_constructors

import 'package:client_app_amacle_studio/pages/loginpage.dart';
import 'package:client_app_amacle_studio/pages/signup_page.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_button/sign_button.dart';

import '../authentication/auth_controller.dart';
import '../global/globals.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3056BB),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: width(context),
                    height: height(context) * 0.4,
                    color: Color(0xff3056BB),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(250, 45),
                      topRight: Radius.elliptical(250, 45),
                    ),
                    child: Container(
                      width: width(context),
                      height: height(context) * 0.6,
                      color: white,
                    ),
                  )
                ],
              ),
              Positioned(
                top: height(context) * 0.27,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Amacle Studios !",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                      addVerticalSpace(width(context) * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(left: 23),
                        child: Text(
                          "Where Dreams Become Digital",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: white,
                          ),
                        ),
                      ),
                      addVerticalSpace(height(context) * 0.03),
                      Center(
                        child: SizedBox(
                          width: width(context) * 0.87,
                          height: width(context) * 0.18,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              hintText: "Email",
                              fillColor: white,
                              filled: true,
                              suffixIcon: Icon(Typicons.at),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(height(context) * 0.03),
                      Center(
                        child: SizedBox(
                          width: width(context) * 0.87,
                          height: width(context) * 0.18,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: passwordcontroller,
                            decoration: InputDecoration(
                              hintText: "Password",
                              fillColor: white,
                              filled: true,
                              suffixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            obscureText: true,
                            obscuringCharacter: '*',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      addVerticalSpace(height(context) * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width(context) * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    color: themeColor,
                                    fontSize: width(context) * 0.036,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(height(context) * 0.05),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: height(context) * 0.01),
                          child: SizedBox(
                            width: width(context) * 0.87,
                            height: width(context) * 0.16,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextButton(
                                onPressed: () {
                                  if (emailcontroller.text.isNotEmpty &&
                                      passwordcontroller.text.isNotEmpty) {
                                    AuthController.instance.register(
                                        emailcontroller.text.trim(),
                                        passwordcontroller.text.trim());
                                    passwordcontroller.text = "";
                                    emailcontroller.text = "";
                                  } else if (emailcontroller.text.isEmpty &&
                                      passwordcontroller.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter the required fields",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else if (emailcontroller.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter the email",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please enter the password",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(width(context) * 0.05),
                      Center(
                        child: Container(
                          height: width(context) * 0.16,
                          child: SignInButton(
                            btnText: " Sign in with Google",
                            buttonType: ButtonType.google,
                            btnColor: white,
                            btnTextColor: Colors.black26,
                            elevation: 0,
                            width: width(context) * 0.78,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            buttonSize: ButtonSize.large,
                            onPressed: () {
                              AuthController.instance
                                  .signInWithGoogle((val) {});
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          width(context) * 0.03,
                          0,
                          width(context) * 0.03,
                          0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 1,
                              width: width(context) * 0.4,
                              decoration:
                                  const BoxDecoration(color: Colors.black26),
                            ),
                            Text(
                              "  or  ",
                              style: TextStyle(
                                fontSize: width(context) * 0.05,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 1,
                              width: width(context) * 0.4,
                              decoration:
                                  const BoxDecoration(color: Colors.black26),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: width(context) * 0.87,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeColor,
                            ),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                replaceScreen(context, LoginPage());
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
