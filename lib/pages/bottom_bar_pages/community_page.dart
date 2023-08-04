// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:client_app_amacle_studio/pages/blog_features/add_blog.dart';
import 'package:client_app_amacle_studio/pages/blog_features/blog_search_screen.dart';
import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/styles.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../global/globals.dart';
import '../../utils/constant.dart';
import '../blog_features/chats_and_blog_details.dart';

class CommunityScreen extends StatefulWidget {
  CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

update(List liked, DocumentSnapshot doc) async {
  if (liked.contains(Global.id)) {
    liked.remove(Global.id);
    await FirebaseFirestore.instance
        .collection("blogs")
        .doc(doc["id"])
        .collection("users")
        .doc(Global.id.toString())
        .delete();
  } else {
    liked.add(Global.id);
    await FirebaseFirestore.instance
        .collection("blogs")
        .doc(doc["id"])
        .collection("users")
        .doc(Global.id.toString())
        .set({
      "time": FieldValue.serverTimestamp(),
      "id": Global.id,
      "image": Global.mainMap[0]["pic"],
    });
  }
  await FirebaseFirestore.instance
      .collection("blogs")
      .doc(doc["id"])
      .update({"liked": liked});
}

Widget callLiked(
    BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc) {
  if (doc["liked"].length >= 3) {
    return likes(context, doc, userDoc, 3);
  } else if (doc["liked"].length == 2) {
    return likes(context, doc, userDoc, 2);
  } else if (doc["liked"].length == 1) {
    return likes(context, doc, userDoc, 1);
  } else {
    return likes(context, doc, userDoc, 0);
  }
}

textCard(BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc) {
  Timestamp? firestoreTimestamp = doc["time"] as Timestamp?;
  DateTime? dateTime;
  String formattedTime = '';

  if (firestoreTimestamp != null) {
    dateTime = firestoreTimestamp.toDate();
    formattedTime = DateFormat('h:mm a').format(dateTime);
  }
  List liked = doc["liked"];
  return Center(
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(
        top: width(context) * 0.03,
        left: width(context) * 0.04,
        right: width(context) * 0.04,
      ),
      width: width(context) * 0.9,
      // height: height(context) * 0.43,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.black26, width: 0.7),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: width(context) * 0.05,
                child: SizedBox(
                  height: width(context) * 0.3,
                  width: width(context) * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageNetwork(
                      userDoc["pic"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              addHorizontalySpace(width(context) * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: userDoc["name"],
                    fontWeight: FontWeight.w700,
                    color: black,
                    size: width(context) * 0.0375,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: doc["time"] == null
                              ? ""
                              : DateFormat('dd MMM yyyy  ')
                                  .format(DateTime.parse(doc["time"]
                                      .toDate()
                                      .toString()
                                      .split(' ')[0]))
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: formattedTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width(context) * 0.75,
                child: AppTextModified(
                  text: doc["text"],
                  color: black,
                  size: width(context) * 0.035,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Divider(color: Colors.black26),
          // addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
                      update(liked, doc);
                    },
                    icon: Icon(
                      doc["liked"].contains(Global.id)
                          ? LineAwesomeIcons.heart_1
                          : LineAwesomeIcons.heart,
                      color:
                          doc["liked"].contains(Global.id) ? Colors.pink : grey,
                    ),
                  ),
                  addHorizontalySpace(width(context) * 0.02),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // FittedBox(child: callLiked(context, doc, userDoc)),
                  // addHorizontalySpace(width(context) * 0.06),
                  AppText(
                    text: doc["liked"].length.toString(),
                    color: doc["liked"].length == 0 ? transparent : black,
                    size: width(context) * 0.04,
                  ),
                ],
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02)
        ],
      ),
    ),
  );
}

oneImageCard(
    BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc) {
  List liked = doc["liked"];
  Timestamp? firestoreTimestamp = doc["time"] as Timestamp?;
  DateTime? dateTime;
  String formattedTime = '';

  if (firestoreTimestamp != null) {
    dateTime = firestoreTimestamp.toDate();
    formattedTime = DateFormat('h:mm a').format(dateTime);
  }
  return Center(
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(
        top: width(context) * 0.03,
        left: width(context) * 0.04,
        right: width(context) * 0.04,
      ),
      width: width(context) * 0.9,
      height: height(context) * 0.47,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.black26, width: 0.7),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: width(context) * 0.05,
                child: SizedBox(
                  height: width(context) * 0.3,
                  width: width(context) * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageNetwork(
                      userDoc["pic"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              addHorizontalySpace(width(context) * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: userDoc["name"],
                    fontWeight: FontWeight.w700,
                    color: black,
                    size: width(context) * 0.0375,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: doc["time"] == null
                              ? ""
                              : DateFormat('dd MMM yyyy  ')
                                  .format(DateTime.parse(doc["time"]
                                      .toDate()
                                      .toString()
                                      .split(' ')[0]))
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: formattedTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: networkImage(
                        doc["images"][0],
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                height: width(context) * 0.46,
                width: width(context) * 0.736,
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width(context) * 0.75,
                child: AppTextModified(
                  text: doc["text"],
                  color: black,
                  size: width(context) * 0.035,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Divider(color: Colors.black26),
          // addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
                      update(liked, doc);
                    },
                    icon: Icon(
                      doc["liked"].contains(Global.id)
                          ? LineAwesomeIcons.heart_1
                          : LineAwesomeIcons.heart,
                      color:
                          doc["liked"].contains(Global.id) ? Colors.pink : grey,
                    ),
                  ),
                  addHorizontalySpace(width(context) * 0.02),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // FittedBox(child: callLiked(context, doc, userDoc)),
                  // addHorizontalySpace(width(context) * 0.06),
                  AppText(
                    text: doc["liked"].length.toString(),
                    color: doc["liked"].length == 0 ? transparent : black,
                    size: width(context) * 0.04,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}

twoImageCard(
    BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc) {
  List liked = doc["liked"];
  Timestamp? firestoreTimestamp = doc["time"] as Timestamp?;
  DateTime? dateTime;
  String formattedTime = '';

  if (firestoreTimestamp != null) {
    dateTime = firestoreTimestamp.toDate();
    formattedTime = DateFormat('h:mm a').format(dateTime);
  }
  return Center(
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(
        top: width(context) * 0.03,
        left: width(context) * 0.04,
        right: width(context) * 0.04,
      ),
      width: width(context) * 0.9,
      height: height(context) * 0.47,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.black26, width: 0.7),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: width(context) * 0.05,
                child: SizedBox(
                  height: width(context) * 0.3,
                  width: width(context) * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageNetwork(
                      userDoc["pic"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              addHorizontalySpace(width(context) * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: userDoc["name"],
                    fontWeight: FontWeight.w700,
                    color: black,
                    size: width(context) * 0.0375,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: doc["time"] == null
                              ? ""
                              : DateFormat('dd MMM yyyy  ')
                                  .format(DateTime.parse(doc["time"]
                                      .toDate()
                                      .toString()
                                      .split(' ')[0]))
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: formattedTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: networkImage(
                        doc["images"][0],
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                height: width(context) * 0.46,
                width: width(context) * 0.46,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: networkImage(
                            doc["images"][1],
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    height: width(context) * 0.22,
                    width: width(context) * 0.22,
                  ),
                  addVerticalSpace(width(context) * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    height: width(context) * 0.22,
                    width: width(context) * 0.22,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black26.withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        height: width(context) * 0.22,
                        width: width(context) * 0.22,
                        child: Center(
                          child: AppText(
                            text: "More ᐳ",
                            color: black,
                            size: width(context) * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width(context) * 0.75,
                child: AppTextModified(
                  text: doc["text"],
                  color: black,
                  size: width(context) * 0.035,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Divider(color: Colors.black26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
                      update(liked, doc);
                    },
                    icon: Icon(
                      doc["liked"].contains(Global.id)
                          ? LineAwesomeIcons.heart_1
                          : LineAwesomeIcons.heart,
                      color:
                          doc["liked"].contains(Global.id) ? Colors.pink : grey,
                    ),
                  ),
                  addHorizontalySpace(width(context) * 0.02),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // FittedBox(child: callLiked(context, doc, userDoc)),
                  // addHorizontalySpace(width(context) * 0.06),
                  AppText(
                    text: doc["liked"].length.toString(),
                    color: doc["liked"].length == 0 ? transparent : black,
                    size: width(context) * 0.04,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}

threeImageCard(
    BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc) {
  List liked = doc["liked"];
  Timestamp? firestoreTimestamp = doc["time"] as Timestamp?;
  DateTime? dateTime;
  String formattedTime = '';

  if (firestoreTimestamp != null) {
    dateTime = firestoreTimestamp.toDate();
    formattedTime = DateFormat('h:mm a').format(dateTime);
  }
  return Center(
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(
        top: width(context) * 0.03,
        left: width(context) * 0.04,
        right: width(context) * 0.04,
      ),
      width: width(context) * 0.9,
      height: height(context) * 0.47,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.black26, width: 0.7),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: width(context) * 0.05,
                child: SizedBox(
                  height: width(context) * 0.3,
                  width: width(context) * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageNetwork(
                      userDoc["pic"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              addHorizontalySpace(width(context) * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: userDoc["name"],
                    fontWeight: FontWeight.w700,
                    color: black,
                    size: width(context) * 0.0375,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: doc["time"] == null
                              ? ""
                              : DateFormat('dd MMM yyyy  ')
                                  .format(DateTime.parse(doc["time"]
                                      .toDate()
                                      .toString()
                                      .split(' ')[0]))
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: formattedTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: networkImage(
                        doc["images"][0],
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                height: width(context) * 0.46,
                width: width(context) * 0.46,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: networkImage(
                            doc["images"][1],
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    height: width(context) * 0.22,
                    width: width(context) * 0.22,
                  ),
                  addVerticalSpace(width(context) * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: networkImage(
                            doc["images"][2],
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    height: width(context) * 0.22,
                    width: width(context) * 0.22,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        height: width(context) * 0.22,
                        width: width(context) * 0.22,
                        child: Center(
                          child: AppText(
                            text: "More",
                            size: width(context) * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width(context) * 0.75,
                child: AppTextModified(
                  text: doc["text"],
                  color: black,
                  size: width(context) * 0.035,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          addVerticalSpace(height(context) * 0.02),
          Divider(color: Colors.black26),
          // addVerticalSpace(height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
                      update(liked, doc);
                    },
                    icon: Icon(
                      doc["liked"].contains(Global.id)
                          ? LineAwesomeIcons.heart_1
                          : LineAwesomeIcons.heart,
                      color:
                          doc["liked"].contains(Global.id) ? Colors.pink : grey,
                    ),
                  ),
                  addHorizontalySpace(width(context) * 0.02),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // FittedBox(child: callLiked(context, doc, userDoc)),
                  // addHorizontalySpace(width(context) * 0.06),
                  AppText(
                    text: doc["liked"].length.toString(),
                    color: doc["liked"].length == 0 ? transparent : black,
                    size: width(context) * 0.04,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}

likes(BuildContext context, DocumentSnapshot doc, DocumentSnapshot userDoc,
    int count) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("blogs")
          .doc(doc["id"])
          .collection("users")
          .orderBy("time", descending: true)
          .limit(count != 0 ? count : 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return SizedBox(
            width: width(context) * 0.3,
            height: width(context) * 0.05 * 2,
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: transparent,
                  maxRadius: width(context) * 0.05,
                  child: SizedBox(
                    height: width(context) * 0.3,
                    width: width(context) * 0.3,
                    child: count >= 3
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: imageNetwork(
                              documents[2]["image"],
                              fit: BoxFit.cover,
                            ),
                          )
                        : nullWidget(),
                  ),
                ),
                Positioned(
                  left: width(context) * 0.05,
                  child: CircleAvatar(
                    backgroundColor: transparent,
                    maxRadius: width(context) * 0.05,
                    child: SizedBox(
                      height: width(context) * 0.3,
                      width: width(context) * 0.3,
                      child: count >= 2
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageNetwork(
                                documents[1]["image"],
                                fit: BoxFit.cover,
                              ),
                            )
                          : nullWidget(),
                    ),
                  ),
                ),
                Positioned(
                  left: width(context) * 0.09,
                  child: CircleAvatar(
                    backgroundColor: transparent,
                    maxRadius: width(context) * 0.05,
                    child: SizedBox(
                      height: width(context) * 0.3,
                      width: width(context) * 0.3,
                      child: count >= 1
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageNetwork(
                                documents[0]["image"],
                                fit: BoxFit.cover,
                              ),
                            )
                          : nullWidget(),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return nullWidget();
        }
      });
}

int itemCount = 10;

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        itemCount += 5;
      });
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Color color = Color.fromARGB(255, 243, 242, 242);
    return SafeArea(
      child: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          title: Text(
            "Blogs",
            style: TextStyle(
                fontSize: 18, color: black, fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              onPressed: () {
                nextScreen(context, BlogSearchScreen());
              },
              icon: Icon(
                Icons.search,
                color: themeColor,
              ),
            ),
            IconButton(
              onPressed: () {
                nextScreen(context, AddBlog());
              },
              icon: Icon(
                Icons.add,
                color: themeColor,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(color: color),
            child: Container(
              padding: EdgeInsets.only(
                  left: width(context) * 0.08, right: width(context) * 0.08),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("blogs")
                      .orderBy("time", descending: true)
                      .limit(itemCount)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      log(documents.length.toString());
                      return Column(
                        children: List.generate(
                          documents.length,
                          (index) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where("id",
                                      isEqualTo: documents[index]["user_id"])
                                  .snapshots(),
                              builder: (context, snaps) {
                                if (snapshot.hasData && snaps.data != null) {
                                  DocumentSnapshot userDoc =
                                      snaps.data!.docs[0];
                                  return Slidable(
                                    endActionPane: ActionPane(
                                      motion: StretchMotion(),
                                      children: [
                                        if (documents[index]["user_id"] ==
                                            Global.id)
                                          SlidableAction(
                                            onPressed: (context) {
                                              print(documents[index]["id"]);
                                              FirebaseFirestore.instance
                                                  .collection("blogs")
                                                  .doc(documents[index]["id"])
                                                  .delete()
                                                  .then((value) async {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(Global.id.toString())
                                                    .collection("my_blogs")
                                                    .doc(documents[index]["id"])
                                                    .delete();

                                                for (String img
                                                    in documents[index]
                                                        ["images"]) {
                                                  Reference ref =
                                                      FirebaseStorage.instance
                                                          .refFromURL(img);
                                                  try {
                                                    await ref.delete();
                                                    print(
                                                        'File deleted successfully.');
                                                  } catch (e) {
                                                    print(
                                                        'Error deleting file: $e');
                                                  }
                                                }
                                              });
                                            },
                                            icon: Icons.delete,
                                            foregroundColor: Colors.red,
                                            backgroundColor: transparent,
                                            label: "Delete",
                                          ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            ChatsAndBlogPage(
                                              doc: documents[index],
                                              userDoc: userDoc,
                                            ));
                                      },
                                      child: documents[index]["images"]
                                                  .length ==
                                              0
                                          ? textCard(context, documents[index],
                                              userDoc)
                                          : documents[index]["images"].length ==
                                                  1
                                              ? oneImageCard(context,
                                                  documents[index], userDoc)
                                              : documents[index]["images"]
                                                          .length ==
                                                      2
                                                  ? twoImageCard(context,
                                                      documents[index], userDoc)
                                                  : threeImageCard(
                                                      context,
                                                      documents[index],
                                                      userDoc),
                                    ),
                                  );
                                } else {
                                  return nullWidget();
                                }
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return nullWidget();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
