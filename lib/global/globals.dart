import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static String phone = "";
  static String email = "";
  static String role = "";
  static String name = "";
  static bool isNew = false;
  static int id = -1;
  static TextEditingController searchcontroller = TextEditingController();
  static List mainMap = [];

  destroy() {
    phone = "";
    email = "";
    id = -1;
    role = "";
    name = "";

    removePhoneNumber();
    removeEmail();
    removeRole();
    removeName();

    log("destroyed");
  }

  fetchData() {
    getPhoneNumber().then((phoneNumber) async {
      print('Phone Number: $phoneNumber');
      Global.phone = phoneNumber;
    });
    getEmail().then((email) async {
      print('Email: $email');
      Global.email = email;
    });
    getRole().then((rol) async {
      print('Login: $rol');
      Global.role = rol;
    });
    getName().then((nm) async {
      print('Name: $nm');
      Global.name = nm;
    });
  }

  void savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcClientPhoneNumber', phoneNumber);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcClientPhoneNumber') ?? "";
  }

  void removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcClientPhoneNumber');
  }

  void saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcClientEmail', email);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcClientEmail') ?? "";
    ;
  }

  void removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcClientEmail');
  }

  void saveRole(String log) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcClientRole', log);
  }

  Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcClientRole') ?? "";
  }

  void removeRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcClientRole');
  }

  void saveName(String log) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcClientName', log);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcClientName') ?? "";
  }

  void removeName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcClientName');
  }
}
