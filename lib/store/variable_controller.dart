import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:atlantis_space/generated_grpc/models_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import 'package:shared_preferences/shared_preferences.dart';

import 'configurations.dart';

class Local_Storage_Keys {
  static const install_date = "install_date";
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

  String get_displayable_app_name(String name_end_with_apk) {
    try {
      var name = name_end_with_apk.split(".").first;
      return name[0].toUpperCase() + name.substring(1, name.length);
    } catch (e) {
      return "";
    }
  }

  String _get_app_name_end_with_apk(String path) {
    var name_end_with_apk = path.split('/').last;
    return name_end_with_apk;
  }

  Future<String?> get_local_apk_parent_folder_path() async {
    var data_ = await Variable_Controllr.kotlin_functions
        .invokeMethod('get_local_apk_parent_folder_path', <String, dynamic>{});
    if (data_ == "") {
      return null;
    } else {
      return data_;
    }
  }

  Future<void> release_built_in_apk_files(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> apk_file_list = manifestMap.keys
        .where((String key) => key.contains('apks/'))
        .where((String key) => key.contains('.apk'))
        .toList();

    String? local_apk_parent_folder = await get_local_apk_parent_folder_path();
    if (local_apk_parent_folder == null) {
      return;
    }

    for (final apk_asset_path in apk_file_list) {
      var apk_file_name = _get_app_name_end_with_apk(apk_asset_path);
      var target_apk_path =
          File(path.join(local_apk_parent_folder, apk_file_name));
      if (!target_apk_path.existsSync()) {
        ByteData data = await rootBundle.load(apk_asset_path);
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(target_apk_path.path).writeAsBytes(bytes);
      }
    }
  }

  // data
  String? install_date;

  String get_current_datetime() {
    var now = DateTime.now();
    return now.toString();
  }

  bool check_if_now_is_one_month_later() {
    if (install_date == null) {
      return false;
    }

    final old_time = DateTime.parse(install_date!);

    final one_month_later = old_time.add(Duration(days: 30));
    final now = DateTime.now();

    if (now.compareTo(one_month_later) == 1) {
      return true;
    } else {
      return false;
    }
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

    install_date = preferences?.getString(Local_Storage_Keys.user_email);

    jwt = preferences?.getString(Local_Storage_Keys.jwt);
    user_email = preferences?.getString(Local_Storage_Keys.user_email);
    username = preferences?.getString(Local_Storage_Keys.username);
  }

  Future<void> setup_built_in_apk_files(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: null,
              content: Text(
                "Working on...\n\nWait until something happen!",
                style: TextStyle(color: Colors.black),
              ),
              actions: null);
        });

    await release_built_in_apk_files(context);

    await load_app_list(load_outside_app: true, load_inside_app: true);
    refresh_app_list();
  }

  Future<void> save_install_date() async {
    if (this.install_date == null) {
      await preferences?.setString(
          Local_Storage_Keys.install_date, get_current_datetime());
    }
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
