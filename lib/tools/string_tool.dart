String get_sub_string(String? source_string, int index_start, int index_end,
    {bool add_dots = false}) {
  if (source_string == null) {
    return "";
  }

  if (source_string.length <= index_end) {
    return source_string;
  }

  String result = source_string.substring(index_start, index_end);
  if (add_dots) {
    return "$result...";
  } else {
    return result;
  }
}
