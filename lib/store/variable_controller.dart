import 'dart:convert';
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
  List<App_Model> inside_app_list = [];
  RxList<App_Model> outside_app_list_for_view = RxList<App_Model>([]);
  RxList<App_Model> inside_app_list_for_view = RxList<App_Model>([]);
  String search_keywords = "";

  Future<void> load_app_list(
      {bool load_outside_app = false, bool load_inside_app = false}) async {
    // get outside apps
    if (load_outside_app) {
      var json_string = await Variable_Controllr.kotlin_functions
          .invokeMethod('get_all_installed_apps', <String, dynamic>{});
      List a_list_of_app_data = jsonDecode(json_string);

      List<App_Model> less_important_apps = [];
      outside_app_list.clear();
      for (final one in a_list_of_app_data) {
        var an_app = App_Model().from_dict(one);

        if (an_app.app_id != null &&
            an_app.app_id!.startsWith("com.android.")) {
          less_important_apps.add(an_app);
          continue;
        }

        if (an_app.app_name != null && an_app.app_name!.contains('.')) {
          less_important_apps.add(an_app);
          continue;
        }

        outside_app_list.add(an_app);
      }
      outside_app_list.addAll(less_important_apps);
    }

    // get inside apps
    if (load_inside_app) {
      var json_string = await Variable_Controllr.kotlin_functions
          .invokeMethod('get_all_saved_apps', <String, dynamic>{});
      var a_list_of_app_data = jsonDecode(json_string);

      inside_app_list.clear();
      for (final one in a_list_of_app_data) {
        var an_app = App_Model().from_dict(one);

        inside_app_list.add(an_app);
      }
    }
  }

  void refresh_app_list() {
    List<App_Model> temp_outside_app_list = [];
    for (final one in outside_app_list) {
      var app_name = one.app_name;
      if (app_name == null) {
        continue;
      }
      if (app_name.toLowerCase().contains(search_keywords.toLowerCase())) {
        temp_outside_app_list.add(one);
      }
    }
    outside_app_list_for_view.clear();
    outside_app_list_for_view.addAll(temp_outside_app_list);

    List<App_Model> temp_inside_app_list = [];
    for (final one in inside_app_list) {
      var app_name = one.app_name;
      if (app_name == null) {
        continue;
      }
      if (app_name.toLowerCase().contains(search_keywords.toLowerCase())) {
        temp_inside_app_list.add(one);
      }
    }
    inside_app_list_for_view.clear();
    inside_app_list_for_view.addAll(temp_inside_app_list);
  }

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
