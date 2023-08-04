// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:client_app_amacle_studio/global/globals.dart';
import 'package:client_app_amacle_studio/pages/enter_referral_code_later.dart';
import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:client_app_amacle_studio/utils/styles.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RefferalScreen extends StatefulWidget {
  const RefferalScreen({Key? key}) : super(key: key);

  @override
  _RefferalScreenState createState() => _RefferalScreenState();
}

class _RefferalScreenState extends State<RefferalScreen> {
  TextEditingController controller = TextEditingController();

  Widget bannerComponents(String image, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: width(context) * 0.25,
          height: width(context) * 0.25,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        addVerticalSpace(height(context) * 0.01),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: white,
            fontSize: width(context) * 0.03,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget arrow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: width(context) * 0.06,
      height: width(context) * 0.03,
      child: Image.asset(
        "assets/arrow.png",
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.text = Global.mainMap[0]["my_referral_code"];
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width(context),
                height: height(context) * 0.4,
                color: Color(0xff355bc0),
                child: Column(
                  children: <Widget>[
                    addVerticalSpace(height(context) * 0.05),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            goBack(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                            size: width(context) * 0.08,
                          ),
                        ),
                        addHorizontalySpace(width(context) * 0.06),
                        AppText(
                          text: "Referral Code",
                          color: white,
                          size: width(context) * 0.05,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    addVerticalSpace(height(context) * 0.04),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bannerComponents(
                          "assets/referral1.png",
                          "Refer a friend.",
                        ),
                        arrow(),
                        bannerComponents(
                          "assets/referral2.png",
                          "Earn a bonus\non joining",
                        ),
                        arrow(),
                        bannerComponents(
                          "assets/referral3.png",
                          "50% off on\nyour first project",
                        ),
                      ],
                    )
                  ],
                ),
              ),
              addVerticalSpace(height(context) * 0.03),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: width(context),
                height: height(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // addVerticalSpace(height(context) * 0.05),
                    Text(
                      "Referral Code",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.02),
                    Text(
                      "Send this referral code to you colleagues and when they make an account using your referral code, they get a bonus",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.fiber_manual_record,
                                    color: Colors.black38,
                                    size: 10,
                                  ),
                                ],
                              ),
                              addHorizontalySpace(10),
                              SizedBox(
                                width: width(context) * 0.8,
                                child: AppText(
                                  text:
                                      "When someone who has used this referral code gets a project made, you get 5% of te total amount as your wallet balance.",
                                  color: Colors.black38,
                                  size: width(context) * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(5),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.fiber_manual_record,
                        //       color: black,
                        //       size: 10,
                        //     ),
                        //     addHorizontalySpace(10),
                        //     AppText(
                        //       text:
                        //           "This code will enable a one time offer special offers.",
                        //       color: black,
                        //       size: width(context) * 0.035,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ],
                        // ),
                        // addVerticalSpace(5),
                        Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              color: Colors.black38,
                              size: 10,
                            ),
                            addHorizontalySpace(10),
                            AppText(
                              text: "This code can be used only once.",
                              color: Colors.black38,
                              size: width(context) * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                    addVerticalSpace(height(context) * 0.05),
                    Center(
                      child: SizedBox(
                        width: width(context) * 0.75,
                        height: width(context) * 0.18,
                        child: TextField(
                          enabled: true,
                          readOnly: true,
                          controller: controller,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFFCF4A7),
                            suffixIcon: IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: Global.mainMap[0]["my_referral_code"],
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: "Referral Code copied",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.black54,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.04),
                    AppText(
                      text: "Do you have a referral Code ?",
                      color: Colors.black38,
                      size: width(context) * 0.04,
                      fontWeight: FontWeight.w500,
                    ),

                    addVerticalSpace(height(context) * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (Global.mainMap[0]["referral_entered"] == "") {
                              nextScreen(context, EnterReferralCodeLater());
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "You have already entered a valid referral code.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          },
                          child: AppText(
                            text: "Redeem Code",
                            color: btnColor,
                            size: width(context) * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppText(
                          text: "T&C* Apply",
                          color: btnColor,
                          size: width(context) * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    addVerticalSpace(height(context) * 0.04),
                    Text(
                      "Current wallet balance:  ₹${Global.mainMap[0]["wallet"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.04),
                    Text(
                      "See all who have used your referral code.",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.02),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("referrals")
                            .where("code", isEqualTo: controller.text)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> docs = snapshot.data!.docs;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                    docs[0]["used_by"].length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .where("id",
                                                isEqualTo: docs[0]["used_by"]
                                                    [index])
                                            .snapshots(),
                                        builder: (context, snaps) {
                                          if (snaps.hasData) {
                                            List<DocumentSnapshot> list =
                                                snaps.data!.docs;
                                            log(list.toString());
                                            return CircleAvatar(
                                              maxRadius: 25,
                                              backgroundColor: themeColor,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: SizedBox(
                                                  width: width(context) * 0.63,
                                                  height: width(context) * 0.63,
                                                  child: imageNetwork(
                                                    list[0]["pic"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return nullWidget();
                                          }
                                        }),
                                  );
                                }),
                              ),
                            );
                          } else {
                            return nullWidget();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
