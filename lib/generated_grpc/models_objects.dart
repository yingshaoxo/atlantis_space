// ignore_for_file: unused_field



class _Key_string_dict_for_App_Model {
  final String apk_assets_path = "apk_assets_path";
  final String app_id = "app_id";
  final String app_name = "app_name";
  final String app_name_end_with_dot_apk = "app_name_end_with_dot_apk";
  final String app_icon_base64_string = "app_icon_base64_string";
  final String source_apk_path = "source_apk_path";
  final String exported_apk_path = "exported_apk_path";
}

class App_Model {
  String? apk_assets_path;
  String? app_id;
  String? app_name;
  String? app_name_end_with_dot_apk;
  String? app_icon_base64_string;
  String? source_apk_path;
  String? exported_apk_path;

  App_Model({this.apk_assets_path, this.app_id, this.app_name, this.app_name_end_with_dot_apk, this.app_icon_base64_string, this.source_apk_path, this.exported_apk_path});

  final Map<String, dynamic> _property_name_to_its_type_dict = {
    "apk_assets_path": String,
    "app_id": String,
    "app_name": String,
    "app_name_end_with_dot_apk": String,
    "app_icon_base64_string": String,
    "source_apk_path": String,
    "exported_apk_path": String,
  };

  final _key_string_dict_for_App_Model =
      _Key_string_dict_for_App_Model();

  Map<String, dynamic> to_dict() {
    return {
      'apk_assets_path': this.apk_assets_path,
      'app_id': this.app_id,
      'app_name': this.app_name,
      'app_name_end_with_dot_apk': this.app_name_end_with_dot_apk,
      'app_icon_base64_string': this.app_icon_base64_string,
      'source_apk_path': this.source_apk_path,
      'exported_apk_path': this.exported_apk_path,
    };
  }

  App_Model from_dict(Map<String, dynamic>? json) {
    if (json == null) {
      return App_Model();
    }

    this.apk_assets_path = json['apk_assets_path'];
    this.app_id = json['app_id'];
    this.app_name = json['app_name'];
    this.app_name_end_with_dot_apk = json['app_name_end_with_dot_apk'];
    this.app_icon_base64_string = json['app_icon_base64_string'];
    this.source_apk_path = json['source_apk_path'];
    this.exported_apk_path = json['exported_apk_path'];

    return App_Model(
      apk_assets_path: json['apk_assets_path'],
      app_id: json['app_id'],
      app_name: json['app_name'],
      app_name_end_with_dot_apk: json['app_name_end_with_dot_apk'],
      app_icon_base64_string: json['app_icon_base64_string'],
      source_apk_path: json['source_apk_path'],
      exported_apk_path: json['exported_apk_path'],
    );
  }
}


class _Key_string_dict_for_File_Model {
  final String is_folder = "is_folder";
  final String relative_path = "relative_path";
  final String base64_content = "base64_content";
}

class File_Model {
  bool? is_folder;
  String? relative_path;
  String? base64_content;

  File_Model({this.is_folder, this.relative_path, this.base64_content});

  final Map<String, dynamic> _property_name_to_its_type_dict = {
    "is_folder": bool,
    "relative_path": String,
    "base64_content": String,
  };

  final _key_string_dict_for_File_Model =
      _Key_string_dict_for_File_Model();

  Map<String, dynamic> to_dict() {
    return {
      'is_folder': this.is_folder,
      'relative_path': this.relative_path,
      'base64_content': this.base64_content,
    };
  }

  File_Model from_dict(Map<String, dynamic>? json) {
    if (json == null) {
      return File_Model();
    }

    this.is_folder = json['is_folder'];
    this.relative_path = json['relative_path'];
    this.base64_content = json['base64_content'];

    return File_Model(
      is_folder: json['is_folder'],
      relative_path: json['relative_path'],
      base64_content: json['base64_content'],
    );
  }
}