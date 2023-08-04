// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:client_app_amacle_studio/global/globals.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../utils/app_text.dart';
import '../../utils/widgets.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController controller = TextEditingController();
  List<File> selectedImages = [];
  bool sending = false;

  Future<void> pickImages() async {
    final List<XFile>? images = await ImagePicker().pickMultiImage();

    if (images != null) {
      if (selectedImages.length + images.length <= 6) {
        setState(() {
          selectedImages.addAll(images.map((image) => File(image.path)));
        });
      } else {
        // Handle selection limit exceeded error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Selection Limit Exceeded'),
            content: Text('You can only select up to 6 images.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  String docId = "";

  @override
  void initState() {
    docId = generateRandomString(15);
    super.initState();
  }

  Future<void> sendData(String documentId) async {
    setState(() {
      sending = true;
    });
    if (selectedImages.isNotEmpty) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection('blogs');

      List<String> downloadUrls = [];

      for (final imageFile in selectedImages) {
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        List<int>? compressedImage =
            await FlutterImageCompress.compressWithFile(
          imageFile.path,
          quality: 30,
        );
        if (compressedImage != null) {
          Uint8List compressedData = Uint8List.fromList(compressedImage);
          final Reference storageRef =
              storage.ref().child('blogimages/$fileName');

          await storageRef.putData(compressedData);
          final String downloadUrl = await storageRef.getDownloadURL();

          downloadUrls.add(downloadUrl);
        }
      }

      await collection.doc(documentId).set({
        'images': downloadUrls,
        'text': controller.text,
        "user_id": Global.id,
        "id": documentId,
        "likes": 0,
        "liked": [],
        'time': FieldValue.serverTimestamp(),
      }).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(Global.id.toString())
            .collection("my_blogs")
            .doc(documentId)
            .set({
          'time': FieldValue.serverTimestamp(),
          "id": documentId,
        }).then((value) {
          goBack(context);
        });
      });

      setState(() {
        // selectedImages.clear();
        // controller.clear();
      });
    } else {
      if (controller.text.trim().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("blogs")
            .doc(documentId)
            .set({
          'images': [],
          'text': controller.text,
          "user_id": Global.id,
          "id": documentId,
          "likes": 0,
          "liked": [],
          'time': FieldValue.serverTimestamp(),
        }).then((value) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(Global.id.toString())
              .collection("my_blogs")
              .doc(documentId)
              .set({
            'time': FieldValue.serverTimestamp(),
            "id": documentId,
          }).then((value) {
            goBack(context);
          });
        });
      }
    }
    setState(() {
      sending = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    docId = generateRandomString(15);
    print(docId);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: width(context) * 0.03,
          right: width(context) * 0.03,
          top: width(context) * 0.15,
        ),
        width: width(context),
        height: height(context),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: width(context) * 0.08,
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
                      addHorizontalySpace(width(context) * 0.04),
                      AppText(
                        text: Global.mainMap[0]["name"],
                        fontWeight: FontWeight.w700,
                        color: black,
                        size: width(context) * 0.0475,
                      )
                    ],
                  ),
                  SizedBox(
                    width: width(context) * 0.3,
                    height: width(context) * 0.12,
                    child: TextButton(
                      onPressed: () {
                        sendData(docId);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(btnColor)),
                      child: sending
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: white,
                              ),
                            )
                          : AppText(
                              text: "Share",
                            ),
                    ),
                  )
                ],
              ),
              addVerticalSpace(height(context) * 0.05),
              SizedBox(
                width: width(context) * 0.9,
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                      color: black, fontWeight: FontWeight.w400, fontSize: 15),
                  cursorColor: black,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
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
              addVerticalSpace(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: pickImages,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "assets/images.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(30),
              GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: (0.4 / 0.47),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: List.generate(
                  selectedImages.length,
                  (index) => Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(width(context) * 0.06),
                        child: Container(
                          height: width(context) * 0.3,
                          width: width(context) * 0.3,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.06),
                              border: Border.all(
                                color: Colors.black54,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                  selectedImages[index],
                                ),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      Positioned(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            onPressed: () => removeImage(index),
                            icon: Center(
                              child: Icon(
                                Icons.remove_circle,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
