// ignore_for_file: unused_field



class _Key_string_dict_for_App_Model {
  final String apk_assets_path = "apk_assets_path";
  final String app_name_end_with_dot_apk = "app_name_end_with_dot_apk";
  final String app_name = "app_name";
  final String apk_path = "apk_path";
}

class App_Model {
  String? apk_assets_path;
  String? app_name_end_with_dot_apk;
  String? app_name;
  String? apk_path;

  App_Model({this.apk_assets_path, this.app_name_end_with_dot_apk, this.app_name, this.apk_path});

  final Map<String, dynamic> _property_name_to_its_type_dict = {
    "apk_assets_path": String,
    "app_name_end_with_dot_apk": String,
    "app_name": String,
    "apk_path": String,
  };

  final _key_string_dict_for_App_Model =
      _Key_string_dict_for_App_Model();

  Map<String, dynamic> to_dict() {
    return {
      'apk_assets_path': this.apk_assets_path,
      'app_name_end_with_dot_apk': this.app_name_end_with_dot_apk,
      'app_name': this.app_name,
      'apk_path': this.apk_path,
    };
  }

  App_Model from_dict(Map<String, dynamic>? json) {
    if (json == null) {
      return App_Model();
    }

    this.apk_assets_path = json['apk_assets_path'];
    this.app_name_end_with_dot_apk = json['app_name_end_with_dot_apk'];
    this.app_name = json['app_name'];
    this.apk_path = json['apk_path'];

    return App_Model(
      apk_assets_path: json['apk_assets_path'],
      app_name_end_with_dot_apk: json['app_name_end_with_dot_apk'],
      app_name: json['app_name'],
      apk_path: json['apk_path'],
    );
  }
}