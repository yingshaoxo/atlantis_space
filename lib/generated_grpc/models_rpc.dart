import "./models_objects.dart";

import 'dart:convert';
import 'dart:io';

class Client_models {
  /// [_service_url] is something like: "http://127.0.0.1:80" or "https://127.0.0.1"
  /// [_header] http headers, it's a dictionary, liek ('content-type', 'application/json')
  /// [_error_handle_function] will get called when http request got error, you need to give it a function like: (err: String) {print(err)}
  String _service_url = "";
  Map<String, String> _header = Map<String, String>();
  String _special_error_key = "__yingshaoxo's_error__";
  Function(String error_message)? _error_handle_function;

  Client_models(
      {required String service_url,
      Map<String, String>? header,
      Function(String error_message)? error_handle_function}) {
    if (service_url.endsWith("/")) {
      service_url =
          service_url.splitMapJoin(RegExp(r'/$'), onMatch: (p0) => "");
    }
    this._service_url = service_url;

    if (header != null) {
      this._header = header;
    }

    if (error_handle_function == null) {
      error_handle_function = (error_message) {
        print(error_message);
      };
    }
    this._error_handle_function = error_handle_function;
  }

  Future<Map<String, dynamic>> _get_reponse_or_error_by_url_path_and_input(
      String sub_url, Map<String, dynamic> input_dict) async {
    String the_url = "${this._service_url}/models/${sub_url}/";

    var client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    try {
      var the_url_data = Uri.parse(the_url);

      HttpClientRequest request = await client.postUrl(the_url_data);
      request.headers.set('content-type', 'application/json');
      _header.forEach((key, value) {
        request.headers.set(key, value);
      });

      request.add(utf8.encode(json.encode(input_dict)));

      HttpClientResponse response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      final output_dict = json.decode(stringData);
      return output_dict;
    } catch (e) {
      return {_special_error_key: e.toString()};
    } finally {
      client.close();
    }
  }


}