// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:client_app_amacle_studio/global/profile_data.dart';
import 'package:client_app_amacle_studio/pages/loginpage.dart';
import 'package:client_app_amacle_studio/pages/profile.dart';
import 'package:client_app_amacle_studio/pages/signup_page.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_button/sign_button.dart';

import '../authentication/auth_controller.dart';
import '../global/globals.dart';
import 'enter_referral_code.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController companycontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController namecontrolleler = TextEditingController();

  FocusNode focusNode = FocusNode();

  File? icon;

  Future<File> assetToFile(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  gotoNext(BuildContext context, int id) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => EnterReferralCode(id: id)),
      (route) => false,
    );
  }

  bool loading = false;

  sendData(File image, String myReferralCode) async {
    setState(() {
      loading = true;
    });

    String folderPath = 'images/';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        image.path.split('/').last;

    List<int>? compressedImage = await FlutterImageCompress.compressWithFile(
      image.path,
      quality: 30,
    );

    if (compressedImage != null) {
      log("compressed");
      Uint8List compressedData = Uint8List.fromList(compressedImage);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(folderPath + fileName);
      UploadTask uploadTask = ref.putData(compressedData);

      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);

      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      log(downloadUrl);

      int count = 0;

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot snaps = await users.orderBy('id', descending: true).get();

      if (snaps.docs.isNotEmpty) {
        DocumentSnapshot document = snaps.docs.first;
        print('Document ID: ${document.id}');
        count = int.parse(document.id);
      } else {
        count = 0;
        print('No documents found in the collection.');
      }

      DocumentReference documentRef = users.doc((count + 1).toString());

      await documentRef.set({
        "id": count + 1,
        'name': ProfileData.name,
        'role': "client",
        'phno': "+91${ProfileData.phno.trim()}",
        'email': Global.email.trim(),
        "active": "yes",
        "my_referral_code": myReferralCode,
        "referral_entered": "",
        "referral_availed": "yes",
        'linkedin': ProfileData.linkedin,
        'city': ProfileData.city,
        'state': ProfileData.state,
        "pic": downloadUrl,
        "company": companycontroller.text.trim(),
        "wallet": 0,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("referrals")
            .doc(myReferralCode)
            .set({
          "code": myReferralCode,
          "owner": count + 1,
          "used_by": [],
        }).then((value) => gotoNext(context, count + 1));
      }).catchError((error) {
        print('Failed to add data: $error');
        setState(() {
          loading = false;
        });
      });
    }
  }

  doit() async {
    icon = await assetToFile("assets/Avatar.png");
  }

  String myReferralCode = "";

  @override
  void initState() {
    myReferralCode = generateRandomString(15);
    print(myReferralCode);
    super.initState();
  }

  String generateRandomString(int length) =>
      String.fromCharCodes(List.generate(length, (_) {
        int code = math.Random().nextInt(62);
        if (code < 10)
          return code + 48;
        else if (code < 36)
          return code + 55;
        else
          return code + 61; // Lowercase letters a-z
      }));

  @override
  Widget build(BuildContext context) {
    myReferralCode = generateRandomString(15);
    log(myReferralCode);
    doit();
    loading = false;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 46, left: 23),
                    child: Text(
                      "Enter your details",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      "Personel Info",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.03),
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: ProfileData.pic == null
                                ? const Image(
                                    image: AssetImage("assets/Avatar.png"),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    ProfileData.pic!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Stack(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ImagePicker picker = ImagePicker();

                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );

                                  if (pickedFile != null) {
                                    ProfileData.pic = File(pickedFile.path);
                                    setState(() {});
                                  } else {
                                    setState(() {});
                                    print("No image selected");
                                  }
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.5),
                                    color: white,
                                  ),
                                  child: const Icon(
                                      LineAwesomeIcons.alternate_pencil),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.03),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.name = namecontrolleler.text.trim();
                          });
                        },
                        controller: namecontrolleler,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: "Name",
                          suffixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
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
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.phno = phonecontroller.text.trim();
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: phonecontroller,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Phone Number',
                          hintText: "Phone Number",
                          suffixIcon: Icon(Icons.call),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
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
                          setState(() {
                            ProfileData.linkedin =
                                companycontroller.text.trim();
                          });
                        },
                        controller: companycontroller,
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                          hintText: "Company Name",
                          suffixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.01),
                  addVerticalSpace(width(context) * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      "Location Info",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.021),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.state = statecontroller.text.trim();
                          });
                        },
                        controller: statecontroller,
                        decoration: InputDecoration(
                          labelText: 'State',
                          hintText: "State",
                          // suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.04),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.city = citycontroller.text.trim();
                          });
                        },
                        controller: citycontroller,
                        decoration: InputDecoration(
                          labelText: 'City/Region',
                          hintText: "City/Region",
                          // suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height(context) * 0.07),
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextButton(
                        onPressed: () {
                          if (phonecontroller.text.isNotEmpty &&
                              companycontroller.text.isNotEmpty &&
                              statecontroller.text.isNotEmpty &&
                              statecontroller.text.isNotEmpty) {
                            if (ProfileData.pic != null) {
                              setState(() {
                                loading = true;
                              });
                              sendData(ProfileData.pic!, myReferralCode);
                            } else {
                              setState(() {
                                loading = true;
                              });
                              sendData(icon!, myReferralCode);
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "All fields are required",
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
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(5),
            ],
          ),
        ),
      ),
    );
  }
}
