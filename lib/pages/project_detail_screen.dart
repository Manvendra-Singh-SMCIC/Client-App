// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code, use_build_context_synchronously

import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../global/globals.dart';
import '../utils/constant.dart';
import '../utils/styles.dart';
import 'agreement_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({
    Key? key,
    required this.repoOwner,
    required this.repoName,
    required this.token,
    required this.projectId,
    required this.docs,
  }) : super(key: key);

  final String repoOwner;
  final String repoName;
  final String token;
  final int projectId;
  final DocumentSnapshot docs;

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Widget tick(bool isChecked) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: btnColor,
          )
        : Icon(
            Icons.radio_button_unchecked,
            color: Colors.grey,
          );
  }

  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_scrollListener);
    _controller2.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller1.removeListener(_scrollListener);
    _controller2.removeListener(_scrollListener);
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller1.position.userScrollDirection == ScrollDirection.forward) {
      _controller2.jumpTo(_controller1.offset);
    } else if (_controller1.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _controller2.jumpTo(_controller1.offset);
    } else if (_controller2.position.userScrollDirection ==
        ScrollDirection.forward) {
      _controller1.jumpTo(_controller2.offset);
    } else if (_controller2.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _controller1.jumpTo(_controller2.offset);
    }
  }

  Widget line(double width, bool toColor) {
    return Container(
      color: toColor ? btnColor : Colors.grey,
      height: 5.0,
      width: width,
    );
  }

  Widget nullLine(double width) {
    return Container(
      color: transparent,
      height: 5.0,
      width: width,
    );
  }

  Widget spacer(double width) {
    return Container(
      width: width,
    );
  }

  static DateTime now = DateTime.now();

  String day1 = DateFormat('dd').format(now);
  String month1 = DateFormat('MMM').format(now);
  String year1 = DateFormat('yyyy').format(now);

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    controllers[0].text = day1;
    controllers[1].text = month1;
    controllers[2].text = year1;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                addVerticalSpace(height(context) * 0.03),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: width(context) * 0.05),
                          width: width(context) * 0.2,
                          height: width(context) * 0.2,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.03)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(width(context) * 0.03),
                            child: imageNetwork(
                              widget.docs["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        addHorizontalySpace(width(context) * 0.04),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: widget.docs["name"],
                              color: black,
                              fontWeight: FontWeight.w700,
                              size: width(context) * 0.05,
                            ),
                            addVerticalSpace(width(context) * 0.01),
                            AppText(
                              text: "${widget.docs["progress"]}% completed",
                              color: themeColor,
                              fontWeight: FontWeight.w500,
                              size: width(context) * 0.035,
                            ),
                            addVerticalSpace(width(context) * 0.01),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.08),
                              child: SizedBox(
                                width: width(context) * 0.43,
                                height: width(context) * 0.03,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                  height: 3,
                                  child: LinearProgressIndicator(
                                    value: widget.docs["progress"] * 0.01,
                                    minHeight: 2,
                                    backgroundColor: Colors.grey[300],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      btnColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        addHorizontalySpace(width(context) * 0.04),
                        InkWell(
                          onTap: () {
                            nextScreen(
                                context,
                                AgreementScreen(
                                  doc: widget.docs,
                                ));
                          },
                          child: Container(
                            width: width(context) * 0.16,
                            height: width(context) * 0.15,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(3, (index) {
                                    return index == 1
                                        ? addHorizontalySpace(
                                            width(context) * 0.008)
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                width(context) * 0.008),
                                            child: Container(
                                              width: width(context) * 0.072,
                                              height: width(context) * 0.10,
                                              color: btnColor,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    index == 0
                                                        ? Icons.check
                                                        : Icons.close,
                                                    color: white,
                                                    size: width(context) * 0.05,
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                    width:
                                                        width(context) * 0.05,
                                                    child: Divider(
                                                      color: white,
                                                      height: 15,
                                                    ),
                                                  ),
                                                  addVerticalSpace(
                                                      width(context) * 0.008),
                                                  SizedBox(
                                                    height: 3,
                                                    width:
                                                        width(context) * 0.05,
                                                    child: Divider(
                                                      color: white,
                                                      height: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                  }),
                                ),
                                addVerticalSpace(width(context) * 0.007),
                                AppText(
                                  text: "T&c",
                                  color: btnColor,
                                  size: width(context) * 0.03,
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                addVerticalSpace(height(context) * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width(context) * 0.45,
                      height: height(context) * 0.07,
                      padding: EdgeInsets.only(
                        left: width(context) * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: transparent,
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // addHorizontalySpace(width(context) * 0.03),
                              AppText(
                                text: "Manager",
                                color: black,
                                fontWeight: FontWeight.bold,
                                size: width(context) * 0.035,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .where("id",
                                          isEqualTo: widget.docs["manager_id"])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return AppText(
                                        text: snapshot.data!.docs[0]["name"],
                                        color: black,
                                        size: width(context) * 0.032,
                                      );
                                    } else {
                                      return AppText(
                                        text: "Manager",
                                        color: transparent,
                                        fontWeight: FontWeight.bold,
                                        size: width(context) * 0.04,
                                      );
                                    }
                                  }),
                              // addHorizontalySpace(width(context) * 0.04),
                            ],
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.03),
                    GestureDetector(
                      onTap: () {
                        String currentDate =
                            DateFormat('dd MMM yyyy').format(DateTime.now());
                        String currentTime =
                            DateFormat('hh:mm a').format(DateTime.now());
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.docs["manager_id"].toString())
                            .collection("notifications")
                            .add({
                          "timeStamp": FieldValue.serverTimestamp(),
                          "time": currentTime,
                          "date": currentDate,
                          "seen": "no",
                          "role": "Client",
                          "name": Global.mainMap[0]["name"],
                          "image": Global.mainMap[0]["pic"],
                          "msg": "Requested a call",
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.docs["manager_id"].toString())
                              .collection("alerts")
                              .doc("alert")
                              .set({
                            "timeStamp": FieldValue.serverTimestamp(),
                            "time": currentTime,
                            "date": currentDate,
                            "seen": "no",
                          }).then((value) {
                            Fluttertoast.showToast(
                              msg: "Request Sent",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
                          });
                        });
                      },
                      child: Container(
                        width: width(context) * 0.45,
                        height: height(context) * 0.07,
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            addHorizontalySpace(width(context) * 0.03),
                            Icon(Icons.call, color: white),
                            addHorizontalySpace(width(context) * 0.03),
                            AppText(
                              text: "Request call",
                              color: white,
                              size: width(context) * 0.04,
                            ),
                            addHorizontalySpace(width(context) * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(height(context) * 0.01),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("projects")
                          .doc(widget.docs["id"].toString())
                          .collection("milestones")
                          .orderBy("time", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> milestones =
                              snapshot.data!.docs;
                          return SizedBox(
                            width: width(context),
                            child: SingleChildScrollView(
                              controller: _controller1,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      List.generate(milestones.length, (ind) {
                                    return Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width(context) * 0.2,
                                            child: Text(
                                              milestones[ind]["title"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: btnColor,
                                                fontSize:
                                                    width(context) * 0.035,
                                              ),
                                            ),
                                          ),
                                          addHorizontalySpace(
                                            width(context) * 0.155,
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                            ),
                          );
                        } else {
                          return nullWidget();
                        }
                      }),
                ),
                addVerticalSpace(height(context) * 0.02),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("projects")
                          .doc(widget.docs["id"].toString())
                          .collection("milestones")
                          .orderBy("time", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> milestones =
                              snapshot.data!.docs;
                          return SizedBox(
                            width: width(context),
                            height: 50,
                            child: SingleChildScrollView(
                              controller: _controller2,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      List.generate(milestones.length, (index) {
                                    return Container(
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              (index == 0)
                                                  ? nullLine(
                                                      width(context) * 0.04)
                                                  : line(
                                                      width(context) * 0.30,
                                                      milestones[index]
                                                              ["solved"] ==
                                                          "yes"),
                                              tick(milestones[index]
                                                      ["solved"] ==
                                                  "yes"),
                                              Visibility(
                                                visible: index ==
                                                    milestones.length - 1,
                                                child: nullLine(
                                                    width(context) * 0.06),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                            ),
                          );
                        } else {
                          return nullWidget();
                        }
                      }),
                ),
                Row(
                  children: [
                    Text(
                      "Project Tasks",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: width(context) * 0.06,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: width(context) * 0.95,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: width(context) * 0.15,
                          child: TextField(
                            enabled: true,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(now.year - 1),
                                lastDate: DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                ),
                                initialDatePickerMode: DatePickerMode.day,
                                selectableDayPredicate: (date) =>
                                    date.isBefore(now) ||
                                    date.isAtSameMomentAs(now),
                              );

                              if (picked != null) {
                                String formattedDate = picked.day.toString();
                                String formattedMonth =
                                    DateFormat.MMM().format(picked);
                                String formattedYear = picked.year.toString();
                                print('Selected Date: $formattedDate');
                                day1 = controllers[0].text =
                                    formattedDate.length == 1
                                        ? "0$formattedDate"
                                        : formattedDate;
                                month1 = controllers[1].text = formattedMonth;
                                year1 = controllers[2].text = formattedYear;
                                setState(() {});
                              }
                            },
                            controller: controllers[0],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        ),
                        addHorizontalySpace(width(context) * 0.05),
                        SizedBox(
                          width: width(context) * 0.25,
                          child: TextField(
                            enabled: true,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(now.year - 1),
                                lastDate: DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                ),
                                selectableDayPredicate: (date) =>
                                    date.isBefore(now) ||
                                    date.isAtSameMomentAs(now),
                              );

                              if (picked != null) {
                                String formattedDate = picked.day.toString();
                                String formattedMonth =
                                    DateFormat.MMM().format(picked);
                                String formattedYear = picked.year.toString();
                                print('Selected Date: $formattedDate');
                                day1 = controllers[0].text =
                                    formattedDate.length == 1
                                        ? "0$formattedDate"
                                        : formattedDate;
                                month1 = controllers[1].text = formattedMonth;
                                year1 = controllers[2].text = formattedYear;
                                setState(() {});
                              }
                            },
                            controller: controllers[1],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        ),
                        addHorizontalySpace(width(context) * 0.05),
                        SizedBox(
                          width: width(context) * 0.25,
                          child: TextField(
                            enabled: true,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(now.year - 1),
                                lastDate: DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                ),
                                initialDatePickerMode: DatePickerMode.year,
                                selectableDayPredicate: (date) =>
                                    date.isBefore(now) ||
                                    date.isAtSameMomentAs(now),
                              );

                              if (picked != null) {
                                String formattedDate = picked.day.toString();
                                String formattedMonth =
                                    DateFormat.MMM().format(picked);
                                String formattedYear = picked.year.toString();
                                print('Selected Date: $formattedDate');
                                day1 = controllers[0].text =
                                    formattedDate.length == 1
                                        ? "0$formattedDate"
                                        : formattedDate;
                                ;
                                month1 = controllers[1].text = formattedMonth;
                                year1 = controllers[2].text = formattedYear;
                                setState(() {});
                              }
                            },
                            controller: controllers[2],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                            "project_issues/issues/${widget.docs["id"]}")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return Column(
                          children: [
                            documents.length == 0
                                ? nullWidget()
                                : addVerticalSpace(height(context) * 0.04),
                            Column(
                              children:
                                  List.generate(documents.length, (index) {
                                return Visibility(
                                  visible: documents[index]["date"] ==
                                      "${controllers[0].text.trim()} ${controllers[1].text.trim()} ${controllers[2].text.trim()}",
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: width(context) * 0.9,
                                        height: height(context) * 0.16,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width(context) * 0.05),
                                          color: white,
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: width(context) * 0.04,
                                                  top: width(context) * 0.028,
                                                ),
                                                height: height(context) * 0.1,
                                                decoration: BoxDecoration(
                                                  color: transparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        width(context) * 0.05),
                                                    topRight: Radius.circular(
                                                        width(context) * 0.05),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    AppText(
                                                      text: documents[index]
                                                          ["title"],
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      size:
                                                          width(context) * 0.05,
                                                    ),
                                                    AppText(
                                                      text: documents[index]
                                                          ["date"],
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      size: width(context) *
                                                          0.027,
                                                    ),
                                                    AppText(
                                                      text: documents[index]
                                                          ["time_posted"],
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      size: width(context) *
                                                          0.027,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: height(context) * 0.06,
                                                width: width(context) * 0.9,
                                                padding: EdgeInsets.only(
                                                    left:
                                                        width(context) * 0.03),
                                                decoration: BoxDecoration(
                                                  color: documents[index]
                                                              ["solved"] ==
                                                          "yes"
                                                      ? btnColor
                                                      : grey,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        width(context) * 0.05),
                                                    bottomRight:
                                                        Radius.circular(
                                                            width(context) *
                                                                0.05),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      text: documents[index]
                                                          ["desc"],
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      size:
                                                          width(context) * 0.04,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                      addVerticalSpace(height(context) * 0.03),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      } else {
                        return nullWidget();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
