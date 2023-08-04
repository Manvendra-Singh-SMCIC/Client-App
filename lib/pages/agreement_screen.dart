// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../global/globals.dart';
import '../utils/app_text.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({Key? key, required this.doc}) : super(key: key);

  final DocumentSnapshot doc;

  @override
  _AgreementScreenState createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'png',
        'jpg',
        'jpeg'
      ], // Add more file extensions as needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      uploadDocument(file);
    } else {
      Fluttertoast.showToast(
        msg: "Document not selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Future uploadDocument(PlatformFile documentFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    FieldValue time = FieldValue.serverTimestamp();

    var ref = FirebaseStorage.instance
        .ref()
        .child('chatdocuments')
        .child("$fileName.${documentFile.extension}");

    var uploadTask =
        await ref.putFile(File(documentFile.path!)).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String documentUrl = await uploadTask.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("projects")
          .doc(widget.doc["id"].toString())
          .collection("agreements")
          .add({
        "url": documentUrl,
        "name": "Payment Agreement.pdf",
        "approved": "no",
      }).then((value) {
        notifyManager();
        Fluttertoast.showToast(
          msg: "Document Added",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      });
    }
  }

  openFile(String url, String? fileName) async {
    File file = await downloadFile(url, fileName!);

    if (file == null) return;

    print("Path: ${file.path}");

    OpenFile.open(file.path);
  }

  downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 3),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  notifyManager() async {
    String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.doc["manager_id"].toString())
        .collection("notifications")
        .add({
      "timeStamp": FieldValue.serverTimestamp(),
      "time": currentTime,
      "date": currentDate,
      "seen": "no",
      "role": "Manager",
      "name": Global.mainMap[0]["name"],
      "image": Global.mainMap[0]["pic"],
      "msg": "Shared a document for the project ${widget.doc["name"]}",
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.doc["manager_id"].toString())
          .collection("alerts")
          .doc("alert")
          .set({
        "timeStamp": FieldValue.serverTimestamp(),
        "time": currentTime,
        "date": currentDate,
        "seen": "no",
      }).then((value) {
        print("Done");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                addVerticalSpace(height(context) * 0.02),
                Text(
                  "Agreements",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                addVerticalSpace(height(context) * 0.02),
                InkWell(
                  onTap: () {
                    getDocument();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    dashPattern: [5, 5],
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: Container(
                      child: Center(
                        child: Container(
                          height: height(context) * 0.20,
                          width: width(context) * 0.88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  getDocument();
                                },
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset(
                                    "assets/upload1.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              addVerticalSpace(10),
                              InkWell(
                                onTap: () async {
                                  getDocument();
                                },
                                child: Text(
                                  "Click to upload agreements",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              addVerticalSpace(height(context) * 0.01),
                              AppText(
                                text: "Maximum File Size 50 MB",
                                color: Colors.black38,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(height(context) * 0.05),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("projects")
                        .doc(widget.doc["id"].toString())
                        .collection("agreements")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return Column(
                          children: List.generate(documents.length, (index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: "Opening Document",
                                          timeInSecForIosWeb: 1,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        openFile(documents[index]["url"],
                                            documents[index]["name"]);
                                      },
                                      child: Container(
                                        height: width(context) * 0.2,
                                        width: width(context) * 0.16,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: btnColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              width(context) * 0.03),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AppText(
                                              text: "  PDF",
                                              color: btnColor,
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    addHorizontalySpace(width(context) * 0.03),
                                    Container(
                                      width: width(context) * 0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width(context) * 0.6,
                                                child: AppText(
                                                  text: "Payment Agreement.pdf",
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width(context) * 0.1,
                                                child: Icon(
                                                  documents[index]
                                                              ["approved"] ==
                                                          "no"
                                                      ? Icons.close
                                                      : Icons.check,
                                                  color: documents[index]
                                                              ["approved"] ==
                                                          "no"
                                                      ? Colors.red
                                                      : green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          addVerticalSpace(
                                              height(context) * 0.01),
                                          Container(
                                            height: 7,
                                            width: width(context) * 0.7,
                                            decoration: BoxDecoration(
                                              color: documents[index]
                                                          ["approved"] ==
                                                      "no"
                                                  ? Colors.red
                                                  : green,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                addVerticalSpace(height(context) * 0.03),
                              ],
                            );
                          }),
                        );
                      } else {
                        return nullWidget();
                      }
                    }),
                addVerticalSpace(height(context) * 0.03),
                Text(
                  "Terms and Conditions",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                Column(
                  children: List.generate(conditions.length, (index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          width: width(context) * 0.87,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width(context) * 0.1,
                                child: Column(
                                  children: [
                                    addVerticalSpace(4),
                                    Icon(
                                      Icons.fiber_manual_record,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width(context) * 0.77,
                                child: Text(
                                  conditions[index],
                                  style: TextStyle(
                                    color: black,
                                    fontSize: width(context) * 0.033,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(height(context) * 0.02),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> conditions = [
    "Agreement to Terms: By engaging in any business activity with [Your Company Name], you agree to abide by the following terms and conditions.",
    "Scope of Work: The scope of work will be clearly defined and agreed upon by both parties before the project commences. Any changes or additions to the scope of work must be documented and approved in writing.",
    "Payment Terms: Payment terms, including rates, deposit requirements, and invoicing schedules, will be outlined in the project proposal or agreement. Payment is expected within the specified timeframe, and failure to comply may result in project delays or termination.",
    "Intellectual Property: Any intellectual property rights, including copyrights and trademarks, related to the project will be retained by [Your Company Name] unless otherwise stated in writing. The client shall not use or reproduce any of the intellectual property without prior written consent.",
    "Confidentiality: Both parties shall maintain the confidentiality of any proprietary or sensitive information shared during the course of the project. Confidentiality obligations shall remain in effect even after the project is completed.",
    "Project Timeline: A project timeline will be established, outlining key milestones and deadlines. Both parties will make reasonable efforts to adhere to the agreed-upon timeline. However, unforeseen circumstances may lead to timeline adjustments, and communication will be maintained to address any delays or changes.",
    "Communication and Feedback: Clear and timely communication is essential for the success of the project. Both parties will provide feedback, revisions, and approvals within the specified timeframe to ensure project progress and timely completion.",
    "Termination of Agreement: Either party has the right to terminate the agreement if the other party fails to fulfill their obligations as outlined in the terms and conditions. Termination may result in financial implications or forfeiture of any completed work or project materials.",
    "Limitation of Liability: [Your Company Name] shall not be liable for any indirect, incidental, or consequential damages arising from the project or its implementation. The client agrees to indemnify and hold [Your Company Name] harmless from any claims or liabilities arising from the project.",
    "Governing Law: These terms and conditions shall be governed by and interpreted in accordance with the laws of [Jurisdiction], and any disputes shall be resolved in the courts of [Jurisdiction].",
  ];
}
