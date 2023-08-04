// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:client_app_amacle_studio/authentication/auth_controller.dart';
import 'package:client_app_amacle_studio/global/globals.dart';
import 'package:client_app_amacle_studio/pages/bottom_bar_pages/notification_screen.dart';
import 'package:client_app_amacle_studio/pages/enter_referral_code.dart';
import 'package:client_app_amacle_studio/pages/project_detail_screen.dart';
import 'package:client_app_amacle_studio/pages/refferal_screen.dart';
import 'package:client_app_amacle_studio/pages/user_profile.dart';
import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/styles.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constant.dart';
import 'package:flutter/services.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  late bool isShowingMainData;

  late TabController _tabController;

  TextEditingController searchcontroller = TextEditingController();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isShowingMainData = true;
  }

  Uri uri = Uri.parse("http://amaclestudio.com/");

  Column inProgressAndFinished(List<DocumentSnapshot> docs) {
    int percent = 100;

    return Column(
      children: List.generate(
        docs.length,
        (index) {
          bool finished = docs[index]["status"] == "finished";
          return Builder(builder: (context) {
            return Column(
              children: [
                addVerticalSpace(height(context) * 0.01),
                Container(
                  width: 0.9 * width(context),
                  // height: 0.11 * height(context),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
                  child: InkWell(
                    onTap: () {
                      if (!finished) {
                        nextScreen(
                          context,
                          ProjectDetailScreen(
                            repoOwner: docs[index]["repo_owner"],
                            repoName: docs[index]["repo_name"],
                            token: docs[index]["token"],
                            projectId: docs[index]["id"],
                            docs: docs[index],
                          ),
                        );
                      }
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width(context) * 0.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  addVerticalSpace(height(context) * 0.01),
                                  Container(
                                    height: width(context) * 0.17,
                                    width: width(context) * 0.17,
                                    // maxRadius: width(context) * 0.1,
                                    // backgroundColor: themeColor.withOpacity(0.12),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          width(context) * 0.1),
                                      child: imageNetwork(
                                        docs[index]["image"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 1.5,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                width(context) * 0.02,
                                width(context) * 0.05,
                                width(context) * 0.01,
                                width(context) * 0.02,
                              ),
                              width: width(context) * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addHorizontalySpace(width(context) * 0.025),
                                  AppText(
                                    text: docs[index]["name"],
                                    color: black,
                                    size: width(context) * 0.042,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  addVerticalSpace(height(context) * 0.01),
                                  AppText(
                                    text: "${docs[index]["progress"]}%",
                                    size: width(context) * 0.037,
                                    color: percent == 100
                                        ? Colors.blue
                                        : Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: docs[index]["status"] == "finished",
                          child: Container(
                            height: width(context) * 0.14,
                            width: width(context) * 0.2,
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.02),
                            ),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: white,
                                ),
                                AppText(
                                  text: "Delivered",
                                  size: width(context) * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                addVerticalSpace(height(context) * 0.005),
              ],
            );
          });
        },
      ),
    );
  }

  Column maintainence(List<DocumentSnapshot> docs) {
    int percent = 100;

    return Column(
      children: List.generate(
        docs.length,
        (index) {
          return Builder(builder: (context) {
            return Visibility(
              visible: docs[index]["status"] == "maintain",
              child: Column(
                children: [
                  addVerticalSpace(height(context) * 0.01),
                  Container(
                    width: 0.9 * width(context),
                    // height: 0.11 * height(context),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
                    child: InkWell(
                      onTap: () {
                        nextScreen(
                          context,
                          ProjectDetailScreen(
                            repoOwner: docs[index]["repo_owner"],
                            repoName: docs[index]["repo_name"],
                            token: docs[index]["token"],
                            projectId: docs[index]["id"],
                            docs: docs[index],
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width(context) * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                addVerticalSpace(height(context) * 0.01),
                                Container(
                                  height: width(context) * 0.17,
                                  width: width(context) * 0.17,
                                  // maxRadius: width(context) * 0.1,
                                  // backgroundColor: themeColor.withOpacity(0.12),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        width(context) * 0.1),
                                    child: imageNetwork(
                                      docs[index]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 1.5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              width(context) * 0.02,
                              width(context) * 0.05,
                              width(context) * 0.01,
                              width(context) * 0.02,
                            ),
                            width: width(context) * 0.62,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addHorizontalySpace(width(context) * 0.025),
                                AppText(
                                  text: docs[index]["name"],
                                  color: black,
                                  size: width(context) * 0.047,
                                  fontWeight: FontWeight.bold,
                                ),
                                addVerticalSpace(height(context) * 0.01),
                                AppText(
                                  // text: "${docs[index]["progress"]}%",
                                  text: "100%",
                                  size: width(context) * 0.037,
                                  color: percent == 100
                                      ? Colors.blue
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.005),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget bell(bool alert) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 4,
            ),
            IconButton(
              onPressed: () {
                nextScreen(context, NotificationScreen());
                // AuthController.instance.logout();
              },
              icon: Image.asset(
                "assets/BellIcon.png",
                width: width(context) * 0.06,
                color: btnColor,
              ),
            ),
          ],
        ),
        Visibility(
          visible: alert,
          child: Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFF9C706),
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // AuthController.instance.logout();

    bool alert = false;

    return Scaffold(
      // drawer: ChatWidgets.drawer(context),
      backgroundColor: Color(0xFFF3F4F7),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(height(context) * 0.065),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          nextScreen(context, UserProfile());
                        },
                        child: CircleAvatar(
                          maxRadius: width(context) * 0.065,
                          backgroundColor: Color(0xFFB4DBFF),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: SizedBox(
                              width: width(context) * 0.63,
                              height: width(context) * 0.63,
                              child: imageNetwork(
                                Global.mainMap[0]["pic"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      addHorizontalySpace(10),
                      AppText(
                        text: "Welcome",
                        size: width(context) * 0.056,
                        color: black,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          nextScreen(context, RefferalScreen());
                        },
                        child: SizedBox(
                          width: width(context) * 0.1,
                          height: width(context) * 0.1,
                          child: Image.asset(
                            "assets/Cash.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      addHorizontalySpace(20),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(Global.id.toString())
                              .collection("alerts")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<DocumentSnapshot> list = snapshot.data!.docs;
                              if (list.isNotEmpty) {
                                return bell(list[0]["seen"] == "no");
                              } else {
                                return bell(false);
                              }
                            } else {
                              return bell(false);
                            }
                          }),
                    ],
                  ),
                ],
              ),
              addVerticalSpace(height(context) * 0.02),
              AppText(
                text: "Explore our services",
                size: width(context) * 0.046,
                color: black,
                fontWeight: FontWeight.w700,
              ),
              addVerticalSpace(height(context) * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: width(context) * 0.42,
                      height: width(context) * 0.42,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 12, 40, 118),
                          Color.fromARGB(255, 42, 83, 196),
                        ]),
                        borderRadius:
                            BorderRadius.circular(width(context) * 0.05),
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(width(context) * 0.05),
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                width: width(context) * 0.42,
                                height: width(context) * 0.21,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Games',
                                      style: TextStyle(
                                        color: Color(0xFFF3F4F7),
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    addVerticalSpace(6),
                                    Text(
                                      'Explore More',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xE8F3F4F7),
                                        fontSize: 10,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: SizedBox(
                                  width: width(context) * 0.42,
                                  child: Image.asset(
                                    "assets/banner1.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.1),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width(context) * 0.42,
                        height: width(context) * 0.15,
                        decoration: BoxDecoration(
                            color: white,
                            border:
                                Border.all(color: btnColor.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(
                                width(context) * 0.15 / 2),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            addHorizontalySpace(width(context) * 0.02),
                            Text(
                              'View All',
                              style: TextStyle(
                                color: Color(0xB21C1C1B),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // nextScreen(context, RefferalScreen());
                                // nextScreen(context, EnterReferralCode(id: 10));
                              },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                width: width(context) * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      width(context) * 0.15 / 2),
                                  color: btnColor,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      addVerticalSpace(width(context) * 0.03),
                      Container(
                        width: width(context) * 0.42,
                        height: width(context) * 0.24,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(width(context) * 0.05),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 12, 40, 118),
                              Color.fromARGB(255, 42, 83, 196),
                            ])),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(width(context) * 0.05),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 10,
                                child: SizedBox(
                                  width: width(context) * 0.21,
                                  height: width(context) * 0.24,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Websites',
                                        style: TextStyle(
                                          color: Color(0xFFF3F4F7),
                                          fontSize: 17,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      addVerticalSpace(6),
                                      Text(
                                        'More',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xE8F3F4F7),
                                          fontSize: 10,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: SizedBox(
                                  height: width(context) * 0.24,
                                  child: Image.asset(
                                    "assets/banner2.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              addVerticalSpace(height(context) * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: width(context) * 0.42,
                    height: width(context) * 0.24,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(width(context) * 0.05),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 12, 40, 118),
                          Color.fromARGB(255, 42, 83, 196),
                        ])),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(width(context) * 0.05),
                      child: Stack(
                        children: [
                          Positioned(
                            left: width(context) * 0.05,
                            child: SizedBox(
                              height: width(context) * 0.24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Apps',
                                    style: TextStyle(
                                      color: Color(0xFFF3F4F7),
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  addVerticalSpace(6),
                                  AppText(
                                    text: "More",
                                    fontWeight: FontWeight.w400,
                                    size: width(context) * 0.025,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: SizedBox(
                              width: width(context) * 0.21,
                              height: width(context) * 0.24,
                              child: Image.asset(
                                "assets/banner5.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.1),
                  Container(
                    width: width(context) * 0.42,
                    height: width(context) * 0.24,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(width(context) * 0.05),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 12, 40, 118),
                          Color.fromARGB(255, 42, 83, 196),
                        ])),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(width(context) * 0.05),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width(context) * 0.27,
                            height: width(context) * 0.24,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AppText(
                                  text: "Our Finest\nWorks",
                                  fontWeight: FontWeight.w700,
                                  size: width(context) * 0.045,
                                ),
                                addVerticalSpace(6),
                                AppText(
                                  text: "More",
                                  fontWeight: FontWeight.w400,
                                  size: width(context) * 0.025,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              addVerticalSpace(width(context) * 0.03),
                              SizedBox(
                                width: width(context) * 0.15,
                                height: width(context) * 0.21,
                                child: Image.asset(
                                  "assets/banner4.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(height(context) * 0.03),
              AppText(
                text: "Ongoing Projects",
                size: width(context) * 0.046,
                color: black,
                fontWeight: FontWeight.w700,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("projects")
                    .where("client_id", isEqualTo: Global.mainMap[0]["id"])
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    if (documents.isNotEmpty) {
                      return inProgressAndFinished(documents);
                    } else {
                      return Column(
                        children: [
                          addVerticalSpace(40),
                          Center(
                            child: AppText(
                              text: "No ongoing projects.",
                              color: black,
                              size: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Container(
                      width: 0.01,
                      height: 0.01,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
