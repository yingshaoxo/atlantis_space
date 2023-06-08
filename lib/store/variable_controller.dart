import 'dart:core';
import 'package:atlantis_space/generated_grpc/models_objects.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'configurations.dart';

class Local_Storage_Keys {
  static const user_email = "user_email";
  static const jwt = "jwt";
  static const username = "username";
}

class Variable_Controllr extends GetxController {
  SharedPreferences? preferences;

  static const MethodChannel kotlin_functions =
      MethodChannel('my_kotlin_functions');

  // app list
  List<App_Model> outside_app_list = [];
  Rx<String> search_keywords = Rx("");

  // auth
  String? jwt;
  String? user_email;
  String? username;

  // tabs
  int current_tab_index = 0;
  Rx<bool> online = RxBool(true);

  Future<void> initilize_function() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    preferences = await _prefs;

    jwt = preferences?.getString(Local_Storage_Keys.jwt);
    user_email = preferences?.getString(Local_Storage_Keys.user_email);
    username = preferences?.getString(Local_Storage_Keys.username);
  }

  Future<void> save_jwt(String? jwt) async {
    if (jwt != null && jwt != "") {
      this.jwt = jwt;
      await preferences?.setString(Local_Storage_Keys.jwt, jwt);
    }
  }

  Future<void> save_user_email(String? user_email) async {
    if (user_email != null && user_email != "") {
      this.user_email = user_email;
      await preferences?.setString(Local_Storage_Keys.user_email, user_email);
    }
  }

  Future<void> save_username(String? username) async {
    if (username != null && username != "") {
      this.username = username;
      await preferences?.setString(Local_Storage_Keys.username, username);
    }
  }
}
