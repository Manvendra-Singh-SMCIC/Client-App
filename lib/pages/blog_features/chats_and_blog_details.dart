// ignore_for_file: prefer_const_constructors

import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:client_app_amacle_studio/utils/expandable_text.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../global/globals.dart';
import '../../utils/app_text.dart';
import '../../utils/styles.dart';

class ChatsAndBlogPage extends StatefulWidget {
  const ChatsAndBlogPage({super.key, required this.doc, required this.userDoc});

  final DocumentSnapshot doc, userDoc;

  @override
  State<ChatsAndBlogPage> createState() => _ChatsAndBlogPageState();
}

class _ChatsAndBlogPageState extends State<ChatsAndBlogPage> {
  PageController pageController = PageController();
  int pageNumber = 0;
  TextEditingController replycontroller = TextEditingController();

  TextEditingController controller = TextEditingController();

  @override
  initState() {
    super.initState();
    docId = generateRandomString(15);
    likedit = widget.doc["liked"].contains(Global.id);
  }

  bool likedit = false;
  String docId = "";

  String generateRandomString(int length) =>
      String.fromCharCodes(List.generate(length, (_) {
        int code = math.Random().nextInt(62);
        if (code < 10)
          return code + 48; // Digits 0-9
        else if (code < 36)
          return code + 55; // Uppercase letters A-Z
        else
          return code + 61; // Lowercase letters a-z
      }));

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

    setState(() {});
  }

  sendComment(DocumentSnapshot doc, String docId) {
    if (controller.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection("blogs")
          .doc(doc["id"])
          .collection("comments")
          .doc(docId)
          .set({
        "id": docId,
        "time": FieldValue.serverTimestamp(),
        "commenter_id": Global.id,
        "comment": controller.text.trim(),
      }).then((value) {
        controller.clear();
        setState(() {});
      }).catchError((onError) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    docId = generateRandomString(15);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height(context),
          width: width(context),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.doc["images"].length != 0,
                  child: SizedBox(
                    // width: width(context),
                    height: height(context) * 0.35,
                    child: PageView.builder(
                      itemCount: widget.doc["images"].length,
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      onPageChanged: (page) {
                        print(page);
                        pageNumber = page;
                        setState(() {});
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: imageNetwork(
                                widget.doc["images"][index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: height(context) * 0.3,
                              left: 20,
                              child: Container(
                                height: 25,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: AppText(
                                    text:
                                        "${index + 1}/${widget.doc["images"].length}",
                                    size: width(context) * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.doc["images"].length != 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(widget.doc["images"].length, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                pageNumber = index;
                                pageController.animateToPage(
                                  pageNumber,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                                setState(() {});
                              },
                              child: Container(
                                height: width(context) * 0.15,
                                width: width(context) * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: pageNumber == index
                                      ? Border.all(width: 2, color: black)
                                      : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageNetwork(
                                    widget.doc["images"][index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          maxRadius: width(context) * 0.06,
                          child: SizedBox(
                            height: width(context) * 0.3,
                            width: width(context) * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageNetwork(
                                widget.userDoc["pic"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userDoc["name"],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: const Color(0xFF1F2024),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            likedit = !likedit;
                            List liked = widget.doc["liked"];
                            update(liked, widget.doc);
                            setState(() {});
                          },
                          icon: Icon(
                            likedit
                                ? LineAwesomeIcons.heart_1
                                : LineAwesomeIcons.heart,
                            color: likedit ? Colors.pink : grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ExpandableText(
                    text: widget.doc["text"],
                    color: black,
                    textHeight: 500,
                    size: 14,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("blogs")
                        .doc(widget.doc["id"])
                        .collection("comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 20, bottom: 10),
                          child: Text(
                            "${snapshot.data!.docs.length} ${(snapshot.data!.docs.length) == 1 ? "Comment" : "Comments"}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xFF1F2024),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 20, bottom: 10),
                          child: Text(
                            "0 Comments",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xFF1F2024),
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              maxRadius: width(context) * 0.06,
                              child: SizedBox(
                                height: width(context) * 0.3,
                                width: width(context) * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: imageNetwork(
                                    Global.mainMap[0]["pic"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Global.mainMap[0]["name"],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: const Color(0xFF1F2024),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(5),
                        SizedBox(
                          width: width(context) * 0.75,
                          child: TextField(
                            controller: controller,
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                            cursorColor: black,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: btnColor,
                                ),
                                onPressed: () {
                                  print(docId);
                                  setState(() {});
                                  sendComment(widget.doc, docId);
                                },
                              ),
                              hintText: "Write Something Here",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                            ),
                          ),
                        ),
                        addVerticalSpace(height(context) * 0.03),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("blogs")
                                .doc(widget.doc["id"])
                                .collection("comments")
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                return Column(
                                  children:
                                      List.generate(documents.length, (index) {
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .where("id",
                                              isEqualTo: documents[index]
                                                  ["commenter_id"])
                                          .limit(1)
                                          .snapshots(),
                                      builder: (context, snaps) {
                                        Timestamp? firestoreTimestamp =
                                            documents[index]["time"]
                                                as Timestamp?;
                                        String formattedTime = '';

                                        if (firestoreTimestamp != null) {
                                          DateTime dateTime =
                                              firestoreTimestamp.toDate();
                                          formattedTime = DateFormat('h:mm a')
                                              .format(dateTime);
                                        }

                                        if (snapshot.hasData) {
                                          if (snaps.data != null) {
                                            if (snaps.data!.docs.isNotEmpty) {
                                              DocumentSnapshot docs =
                                                  snaps.data!.docs[0];
                                              return Column(
                                                children: [
                                                  Slidable(
                                                    endActionPane: ActionPane(
                                                      motion: StretchMotion(),
                                                      children: [
                                                        if (documents[index][
                                                                "commenter_id"] ==
                                                            Global.id)
                                                          SlidableAction(
                                                            onPressed:
                                                                (context) {
                                                              print(documents[
                                                                  index]["id"]);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "blogs")
                                                                  .doc(widget
                                                                          .doc[
                                                                      "id"])
                                                                  .collection(
                                                                      "comments")
                                                                  .doc(documents[
                                                                          index]
                                                                      ["id"])
                                                                  .delete();
                                                            },
                                                            icon: Icons.delete,
                                                            foregroundColor:
                                                                Colors.red,
                                                            backgroundColor:
                                                                transparent,
                                                            label: "Delete",
                                                          ),
                                                      ],
                                                    ),
                                                    child: ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CircleAvatar(
                                                            maxRadius:
                                                                width(context) *
                                                                    0.06,
                                                            child: SizedBox(
                                                              height: width(
                                                                      context) *
                                                                  0.3,
                                                              width: width(
                                                                      context) *
                                                                  0.3,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child:
                                                                    imageNetwork(
                                                                  docs["pic"],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Text(
                                                                      docs[
                                                                          "name"],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            15,
                                                                        color: const Color(
                                                                            0xFF1F2024),
                                                                      ),
                                                                    ),
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                            text: documents[index]["time"] == null
                                                                                ? ""
                                                                                : DateFormat('dd MMM yyyy  ').format(DateTime.parse(documents[index]["time"].toDate().toString().split(' ')[0])).toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                formattedTime,
                                                                            style:
                                                                                TextStyle(
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
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 7),
                                                        child: Text(
                                                          documents[index]
                                                              ["comment"],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  addVerticalSpace(10),
                                                ],
                                              );
                                            } else {
                                              return nullWidget();
                                            }
                                          } else {
                                            return nullWidget();
                                          }
                                        } else {
                                          return nullWidget();
                                        }
                                      },
                                    );
                                  }),
                                );
                              } else {
                                return nullWidget();
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
