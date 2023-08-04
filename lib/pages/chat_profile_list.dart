import 'dart:developer';

import 'package:client_app_amacle_studio/pages/bottom_bar_pages/chat_profile_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/globals.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';

class ChatProfileList extends StatefulWidget {
  const ChatProfileList({Key? key, required this.currentlyChattingWith})
      : super(key: key);

  final DocumentSnapshot currentlyChattingWith;
  @override
  _ChatProfileListState createState() => _ChatProfileListState();
}

class _ChatProfileListState extends State<ChatProfileList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addVerticalSpace(60),
              Container(
                child: AppText(
                  text: "Select a contact to share",
                  color: black,
                  fontWeight: FontWeight.bold,
                  size: 22,
                ),
              ),
              addVerticalSpace(20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("id", isNotEqualTo: Global.mainMap[0]["id"])
                      .where("role",
                          whereIn: ["manager", "client"]).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      return Column(
                        children: List.generate(documents.length, (index) {
                          return Visibility(
                            visible: documents[index]["id"] !=
                                    Global.mainMap[0]["id"] &&
                                documents[index]["id"] !=
                                    widget.currentlyChattingWith["id"],
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    documents[index]["name"]!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: CircleAvatar(
                                    maxRadius: width(context) * 0.065,
                                    backgroundColor: Color(0xFFB4DBFF),
                                    // backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: width(context) * 0.11,
                                        color: Color(0xFFEAF2FF),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    // String roomId = chatRoomId(
                                    //     Global.id, documents[index]["id"]);
                                    // print(roomId);
                                    nextScreen(
                                        context,
                                        ChatProfileDetails(
                                            doc: documents[index],
                                            chattingWithUser:
                                                widget.currentlyChattingWith,
                                            view: false));
                                  },
                                ),
                                Visibility(
                                  visible: index != documents.length - 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Divider(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
