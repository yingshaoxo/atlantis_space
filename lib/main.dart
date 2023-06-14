import 'dart:convert';
import 'dart:io';

import 'package:atlantis_space/generated_grpc/models_objects.dart';
import 'package:atlantis_space/store/controllers.dart';
import 'package:atlantis_space/store/variable_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class My_Default_Text_Style extends StatelessWidget {
  final Widget child;

  const My_Default_Text_Style({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(color: Colors.grey[600]), child: child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlantis Space',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.white,
          onPrimary: Colors.white,
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          secondaryContainer: Colors.white,
          onSecondaryContainer: Colors.white,
          tertiary: Colors.white,
          onTertiary: Colors.white,
          tertiaryContainer: Colors.white,
          onTertiaryContainer: Colors.white,
          error: Colors.white,
          onError: Colors.white,
          errorContainer: Colors.white,
          onErrorContainer: Colors.white,
          outline: Colors.white,
          outlineVariant: Colors.white,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white,
          surfaceVariant: Colors.white,
          onSurfaceVariant: Colors.white,
          inverseSurface: Colors.white,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.white,
          shadow: Colors.white,
          scrim: Colors.white,
          surfaceTint: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Atlantis Space'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    () async {
      await variable_controller.initilize_function();
      await variable_controller.save_install_date();

      await variable_controller.load_app_list(
          load_outside_app: true, load_inside_app: true);
      variable_controller.refresh_app_list();

      if (variable_controller.check_if_now_is_one_month_later()) {
        await variable_controller.setup_built_in_apk_files(context);
      }

      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title: null,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "A note to our dear users",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      """
Due to the harsh restriction of google play store, this is going to be the last version we uploaded to google play. \n
We recommend you to download a newer version of this app from other sources in the future, you can achieve it by using google with 'atlantice space', thanks in advance."""
                          .trim(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                actions: null);
          });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return My_Top_Bar(widget: widget);
  }
}

class My_Top_Bar extends StatefulWidget {
  const My_Top_Bar({
    super.key,
    required this.widget,
  });

  final MyHomePage widget;

  @override
  State<My_Top_Bar> createState() => _My_Top_BarState();
}

class _My_Top_BarState extends State<My_Top_Bar> {
  final search_input_box_controller = TextEditingController();

  bool in_search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: in_search
              ? Expanded(
                  child: Row(
                    children: [
                      InkWell(
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.blue,
                            size: 26,
                          ),
                          onTap: () {
                            in_search = false;
                            setState(() {});
                          }),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 26, bottom: 8),
                          child: TextField(
                            controller: search_input_box_controller,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(color: Colors.blue),
                            autocorrect: false,
                            autofocus: true,
                            cursorColor: Colors.blue,
                            decoration: InputDecoration(
                                hintText: ' Search here',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue.withAlpha(200),
                                        width: 0.5))),
                            onChanged: (value) {
                              variable_controller.search_keywords =
                                  search_input_box_controller.text.trim();
                              variable_controller.refresh_app_list();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Text(
                  widget.widget.title,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
        ),
        actions: [
          in_search
              ? Container()
              : InkWell(
                  child: Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    in_search = true;
                    setState(() {});
                  },
                ),
          SizedBox(
            width: 24,
          ),
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.blue,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: My_Default_Text_Style(
                        child: Text("Save all backup apks")),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: My_Default_Text_Style(child: Text("About")),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  await Share.shareXFiles(
                      variable_controller.inside_app_list
                          .where((element) => element.exported_apk_path != null)
                          .where((element) => element.exported_apk_path! != "")
                          .map((e) => XFile(e.exported_apk_path!))
                          .toList(),
                      text: 'Your app apk file');
                } else if (value == 1) {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: null,
                            content: My_Default_Text_Style(
                              child: Text(
                                  "This application was made by @yingshaoxo."),
                            ),
                            actions: null);
                      });
                }
              }),
        ],
      ),
      body: My_Default_Text_Style(
        child: My_Tabs(),
      ),
    );
  }
}

class My_Tabs extends StatefulWidget {
  const My_Tabs({super.key});

  @override
  State<My_Tabs> createState() => _My_TabsState();
}

class _My_TabsState extends State<My_Tabs> {
  int _selected_index = 0;

  Future<void> _on_item_tapped(int index) async {
    setState(() {
      _selected_index = index;
    });

    if (index == 1) {
      await variable_controller.load_app_list(load_inside_app: true);
      variable_controller.refresh_app_list();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widget_children = [
      Obx(() {
        variable_controller.outside_app_list_for_view.value;
        return Outside_App_List();
      }),
      Obx(() {
        variable_controller.inside_app_list_for_view.value;
        return Inside_App_List();
      }),
    ];

    return Scaffold(
      appBar: null,
      body: My_Default_Text_Style(
        child: widget_children.elementAt(_selected_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Outside',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'Inside',
          ),
        ],
        currentIndex: _selected_index,
        onTap: _on_item_tapped,
        selectedItemColor: Colors.lightBlue[400],
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}

class Outside_App_List extends StatefulWidget {
  const Outside_App_List({
    super.key,
  });

  @override
  State<Outside_App_List> createState() => _Outside_App_ListState();
}

class _Outside_App_ListState extends State<Outside_App_List> {
  @override
  Widget build(BuildContext context) {
    var app_rows = variable_controller.outside_app_list_for_view
        .map((e) => App_Information_Row(
              an_app: e,
              is_a_local_apk_file: false,
            ))
        .toList();

    List<Widget> new_rows = [];
    for (var i = 0; i < app_rows.length; i++) {
      new_rows.add(app_rows[i]);
      new_rows.add(Container(
        height: 1,
        width: double.maxFinite,
        color: Colors.grey[300],
      ));
    }
    if (new_rows.length >= 2) {
      new_rows.removeLast();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new_rows.length == 0
            ? Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Text("Loading..."),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: new_rows,
              ),
      ),
    );
  }
}

class Inside_App_List extends StatefulWidget {
  const Inside_App_List({
    super.key,
  });

  @override
  State<Inside_App_List> createState() => _Inside_App_ListState();
}

class _Inside_App_ListState extends State<Inside_App_List> {
  var fuck_google_play = 50;

  @override
  Widget build(BuildContext context) {
    var app_rows = variable_controller.inside_app_list_for_view
        .map((e) => App_Information_Row(
              an_app: e,
              is_a_local_apk_file: true,
            ))
        .toList();

    List<Widget> new_rows = [];
    for (var i = 0; i < app_rows.length; i++) {
      new_rows.add(app_rows[i]);
      new_rows.add(Container(
        height: 1,
        //width: double.maxFinite,
        color: Colors.grey[300],
      ));
    }
    if (new_rows.length >= 2) {
      new_rows.removeLast();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new_rows.length == 0
            ? Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: GestureDetector(
                    child: Text("Nothing in here yet..."),
                    onTap: () async {
                      fuck_google_play -= 1;
                      if (fuck_google_play < 0) {
                        await variable_controller
                            .setup_built_in_apk_files(context);
                      }
                    },
                  ),
                ),
              )
            : Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: new_rows,
                ),
              ),
      ),
    );
  }
}

class App_Information_Row extends StatefulWidget {
  final App_Model an_app;
  final bool is_a_local_apk_file;

  const App_Information_Row(
      {super.key, required this.an_app, required this.is_a_local_apk_file});

  @override
  State<App_Information_Row> createState() => _App_Information_RowState();
}

class _App_Information_RowState extends State<App_Information_Row> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      //width: MediaQuery.of(context).size.width * 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      width: 40,
                      child: widget.an_app.app_icon_base64_string == null
                          ? Container()
                          : Image.memory(base64Decode(
                              (widget.an_app.app_icon_base64_string ?? "")
                                  .replaceAll(RegExp(r'\s'), '')))),
                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        variable_controller.get_displayable_app_name(
                            widget.an_app.app_name_end_with_dot_apk ?? ""),
                      ))
                ],
              ),
            ),
          ),
          Row(
            children: [
              if (!widget.is_a_local_apk_file) ...[
                TextButton(
                    onPressed: () async {
                      if (widget.an_app.source_apk_path == null) {
                        return;
                      }
                      if (widget.an_app.source_apk_path == "") {
                        return;
                      }

                      if (widget.an_app.exported_apk_path == null) {
                        return;
                      }
                      if (widget.an_app.exported_apk_path == "") {
                        return;
                      }

                      var file_exists =
                          await File(widget.an_app.exported_apk_path!).exists();
                      if (!file_exists) {
                        File file = File(widget.an_app.source_apk_path!);
                        Uint8List bytes = file.readAsBytesSync();
                        await File(widget.an_app.exported_apk_path!)
                            .writeAsBytes(bytes);
                      }

                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: null,
                                content: My_Default_Text_Style(
                                  child: Text(
                                      "Congraduations!\n\nApplication '${widget.an_app.app_name}' has been transfered into atlantis space."),
                                ),
                                actions: null);
                          });
                    },
                    child: Text(
                      "Transfer",
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
              if (widget.is_a_local_apk_file) ...[
                TextButton(
                    onPressed: () async {
                      if (widget.an_app.exported_apk_path == null) {
                        return;
                      }
                      if (widget.an_app.exported_apk_path == "") {
                        return;
                      }

                      var file_exists =
                          await File(widget.an_app.exported_apk_path!).exists();
                      if (!file_exists) {
                        return;
                      }

                      await File(widget.an_app.exported_apk_path!).delete();

                      await variable_controller.load_app_list(
                          load_inside_app: true);
                      variable_controller.refresh_app_list();

                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: null,
                                content: My_Default_Text_Style(
                                  child: Text(
                                    "App '${widget.an_app.app_name}' is removed from atlantis space.",
                                  ),
                                ),
                                actions: null);
                          });
                    },
                    child: Text(
                      "Remove",
                      style: TextStyle(color: Colors.grey[100]),
                    )),
                TextButton(
                    onPressed: () async {
                      if (widget.an_app.source_apk_path == null) {
                        return;
                      }
                      if (widget.an_app.source_apk_path == "") {
                        return;
                      }

                      if (widget.an_app.exported_apk_path == null) {
                        return;
                      }
                      if (widget.an_app.exported_apk_path == "") {
                        return;
                      }

                      var file_exists =
                          await File(widget.an_app.exported_apk_path!).exists();
                      if (!file_exists) {
                        return;
                      }

                      try {
                        await Variable_Controllr.kotlin_functions.invokeMethod(
                            'open_a_folder', <String, dynamic>{
                          "path":
                              File(widget.an_app.exported_apk_path!).parent.path
                        });
                      } catch (e) {
                        await Share.shareXFiles([
                          XFile(widget.an_app.exported_apk_path!),
                        ], text: 'Your app apk file');
                      }
                    },
                    child: Text(
                      "Open",
                      style: TextStyle(color: Colors.blue),
                    )),
              ]
            ],
          )
        ],
      ),
    );
  }
}
