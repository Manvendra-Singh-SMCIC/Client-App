// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:client_app_amacle_studio/global/globals.dart';
import 'package:client_app_amacle_studio/pages/bottom_bar_pages/bottom_bar_chat_page.dart';
import 'package:client_app_amacle_studio/pages/bottom_bar_pages/home_page.dart';
import 'package:client_app_amacle_studio/pages/bottom_bar_pages/community_page.dart';
import 'package:client_app_amacle_studio/pages/loginpage.dart';
import 'package:client_app_amacle_studio/pages/splash_screen.dart';
import 'package:client_app_amacle_studio/rive/animated_bar.dart';
import 'package:client_app_amacle_studio/utils/app_text.dart';
import 'package:client_app_amacle_studio/utils/constant.dart';
import 'package:client_app_amacle_studio/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:rive/rive.dart';
import 'authentication/auth_controller.dart';
import 'firebase_options.dart';
// import 'rive/rive_assets.dart';
import 'utils/icons.dart';
import 'package:flutter/services.dart';

import 'utils/page_rebuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthController()));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(ChangeNotifierProvider(
    create: (context) => PageRebuilder(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> doit() async {
    await Global().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    doit();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List pages = [
    HomePageScreen(),
    BottomBarCharPage(),
    CommunityScreen(),
  ];

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    }
    return true;
  }

  // RiveAsset selectedBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    BarIcons icons = BarIcons();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: Global.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: loadingState(),
            );
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            Global.mainMap = documents;
            Global.role = Global.mainMap[0]["role"];
            Global.id = Global.mainMap[0]["id"];
            return WillPopScope(
              onWillPop: _onWillPop,
              child: pages[currentIndex],
            );
          } else {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Center(
                child: AppText(
                  text: "An error ocured",
                  color: black,
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(
            color: Color(0xFF1F2024),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 2),
        selectedItemColor: Color(0xFF1F2024),
        unselectedLabelStyle: TextStyle(
          color: Color(0xFF71727A),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        unselectedItemColor: Color(0xFF71727A),
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedIconTheme: null,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
        items: [
          icons.item(
            20,
            20,
            "Home",
            22,
            currentIndex == 0,
            "assets/HomeIcon.png",
          ),
          icons.item(
            20,
            20,
            "Chats",
            22,
            currentIndex == 1,
            "assets/Chat Icon.png",
          ),
          icons.item(
            29,
            30,
            "Community",
            22,
            currentIndex == 2,
            "assets/Community Icon.png",
          ),
        ],
      ),
    );
  }
}

/*
SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavs.length,
                  (index) => GestureDetector(
                    onTap: () {
                      bottomNavs[index].input!.change(true);
                      if (bottomNavs[index] != selectedBottomNav) {
                        setState(() {
                          currentIndex = index;
                          selectedBottomNav = bottomNavs[index];
                        });
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        bottomNavs[index].input!.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(
                            isActive: bottomNavs[index] == selectedBottomNav),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity: bottomNavs[index] == selectedBottomNav 
                                ? 1
                                : 0.5,
                            child: RiveAnimation.asset(
                              bottomNavs.first.src,
                              artboard: bottomNavs[index].artboard,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    RiveUtils.getRiveController(artboard,
                                        stateMachineName:
                                            bottomNavs[index].stateMachineName);

                                bottomNavs[index].input =
                                    controller.findSMI("active") as SMIBool;
                              },
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
 */
