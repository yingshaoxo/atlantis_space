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

  /*
  Future<void> _init_apk_file_list() async {
    in_loading = true;
    setState(() {});

    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> apk_file_list = manifestMap.keys
        .where((String key) => key.contains('apks/'))
        .where((String key) => key.contains('.apk'))
        .toList();

    variable_controller.app_list = [];
    for (final apk_asset_path in apk_file_list) {
      var an_app = App_Model(
        apk_assets_path: apk_asset_path,
        app_name: _get_pure_app_name_from_asset_path(apk_asset_path),
        app_name_end_with_dot_apk: _get_app_name_end_with_apk(apk_asset_path),
      );

      an_app.exported_apk_path =
          await _get_target_apk_path(an_app.app_name_end_with_dot_apk);

      variable_controller.app_list.add(an_app);
    }

    for (final an_app in variable_controller.app_list) {
      if (an_app.exported_apk_path == null || an_app.exported_apk_path == "") {
        continue;
      }

      if (an_app.apk_assets_path == null || an_app.exported_apk_path == "") {
        continue;
      }

      var file_exists = await File(an_app.exported_apk_path!).exists();
      if (!file_exists) {
        ByteData data = await rootBundle.load(an_app.apk_assets_path!);
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(an_app.exported_apk_path!).writeAsBytes(bytes);
      }
    }

    in_loading = false;
  }

  String _get_pure_app_name_from_asset_path(String path) {
    try {
      var name = path.split("/").last.split(".").first;
      return name[0].toUpperCase() + name.substring(1, name.length);
    } catch (e) {
      return "";
    }
  }

  Future<String?> _get_target_apk_path(
      String? app_name_end_with_dot_apk) async {
    Directory? directory = await path_provider.getExternalStorageDirectory();
    // /storage/emulated/0/Android/data/xyz.yingshaoxo.atlantis/files
    if (directory == null) {
      return null;
    }

    if (app_name_end_with_dot_apk == null || app_name_end_with_dot_apk == "") {
      return null;
    }

    var target_saving_path =
        path_.join(directory.absolute.path, app_name_end_with_dot_apk);

    return target_saving_path;
  }
  */

  String _get_app_name_end_with_apk(String path) {
    var name_end_with_apk = path.split('/').last;
    return name_end_with_apk;
  }

  Future<String?> _get_local_apk_parent_folder_path() async {
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

    String? local_apk_parent_folder = await _get_local_apk_parent_folder_path();
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
