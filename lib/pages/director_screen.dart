import 'dart:async';

import 'package:client_app_amacle_studio/authentication/auth_controller.dart';
import 'package:client_app_amacle_studio/pages/splash_screen.dart';
import 'package:client_app_amacle_studio/pages/splash_screen2.dart';
import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../global/globals.dart';
import '../main.dart';

class DirectorScreen extends StatefulWidget {
  const DirectorScreen({Key? key}) : super(key: key);

  @override
  _DirectorScreenState createState() => _DirectorScreenState();
}

class _DirectorScreenState extends State<DirectorScreen> {
  @override
  void initState() {
    super.initState();
  }

  doit(String role) {
    if (role != "client") {
      Fluttertoast.showToast(
        msg: "You are already registered as a developer/manager.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      AuthController.instance.logout();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: Global.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              print(documents[0]["role"]);
              doit(documents[0]["role"]);
              if (documents[0]["role"] == "client") {
                if (mounted) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    Get.offAll(() => SplashScreen2());
                  });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: AppText(text: "", color: black),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: AppText(
                          text:
                              "You are already registered as a ${documents[0]["role"]}",
                          color: black),
                    ),
                  ],
                );
              }
            } else {
              return Container(
                width: width(context),
                height: height(context) * 0.7,
              );
            }
          },
        ),
      ),
    );
  }
}
