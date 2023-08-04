
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/globals.dart';
import '../main.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';

class EnterReferralCodeLater extends StatefulWidget {
  const EnterReferralCodeLater({Key? key}) : super(key: key);

  @override
  _EnterReferralCodeLaterState createState() => _EnterReferralCodeLaterState();
}

class _EnterReferralCodeLaterState extends State<EnterReferralCodeLater> {
  @override
  TextEditingController controller = TextEditingController();
  bool validating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        width: width(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(height(context) * 0.05),
            Text(
              "Enter a Referral Code",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            addVerticalSpace(height(context) * 0.02),
            Text(
              "An existing user of the app can provide you with 15 digit a referral code that can unlock a special offer.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            addVerticalSpace(height(context) * 0.05),
            Center(
              child: SizedBox(
                width: width(context) * 0.9,
                height: height(context) * 0.2,
                child: Image.asset(
                  "assets/refer.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: width(context) * 0.75,
                height: width(context) * 0.18,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [5, 5],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: Center(
                    child: TextField(
                      enabled: true,
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "3zdhe7skim0ayv6",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            addVerticalSpace(height(context) * 0.07),
            Text(
              "Dont have a code now? Don't worry you can enter it later.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: transparent,
                fontWeight: FontWeight.bold,
              ),
            ),
            addVerticalSpace(height(context) * 0.01),
            InkWell(
              onTap: () {
                // Get.offAll(() => HomePage());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Skip",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: transparent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  addHorizontalySpace(10),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: transparent,
                  ),
                  addHorizontalySpace(20),
                ],
              ),
            ),
            addVerticalSpace(height(context) * 0.25),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: width(context) * 0.87,
                height: height(context) * 0.075,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFF00BE9F)),
                  ),
                  onPressed: () {
                    if (!validating && controller.text.trim().isNotEmpty) {
                      String documentId = controller.text.trim();
                      FirebaseFirestore.instance
                          .collection("referrals")
                          .doc(controller.text.trim())
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          List used_by = documentSnapshot.get("used_by");
                          if (!used_by.contains(Global.mainMap[0]["id"])) {
                            used_by.add(Global.mainMap[0]["id"]);
                          }

                          FirebaseFirestore.instance
                              .collection("referrals")
                              .doc(documentId)
                              .update({
                            "used_by": used_by,
                          }).then((_) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(Global.mainMap[0]["id"].toString())
                                .update({
                              "referral_availed": "no",
                              "referral_entered": documentId,
                            }).then((value) {
                              goBack(context);
                            });
                          }).catchError((error) {
                            print("Failed to update document: $error");
                          });
                        } else {
                          // Document doesn't exist
                          print("Invalid referral code");
                          Fluttertoast.showToast(
                            msg: "Invalid referral code",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                        }
                      }).catchError((error) {
                        Fluttertoast.showToast(
                          msg: "Some error occured",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                        print("Failed to fetch document: $error");
                      });
                    }
                  },
                  child: Center(
                    child: validating
                        ? CircularProgressIndicator()
                        : AppText(
                      text: "Validate",
                      color: white,
                      fontWeight: FontWeight.w600,
                      size: width(context) * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}