import 'dart:convert';

import 'package:atlantis_space/generated_grpc/models_objects.dart';
import 'package:atlantis_space/store/controllers.dart';
import 'package:atlantis_space/tools/string_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const MethodChannel kotlin_functions =
      MethodChannel('my_kotlin_functions');

  @override
  void initState() {
    super.initState();

    () async {
      var json_string = await kotlin_functions
          .invokeMethod('get_all_installed_apps', <String, dynamic>{});
      List a_list_of_app_data = jsonDecode(json_string);

      variable_controller.outside_app_list.clear();
      for (final one in a_list_of_app_data) {
        var an_app = App_Model().from_dict(one);

        if (an_app.app_id != null &&
            an_app.app_id!.startsWith("com.android.")) {
          continue;
        }

        if (an_app.app_name != null && an_app.app_name!.contains('.')) {
          continue;
        }

        variable_controller.outside_app_list.add(an_app);
      }

      setState(() {});
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
                              variable_controller.search_keywords.trigger(
                                  search_input_box_controller.text.trim());
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
                    child: My_Default_Text_Style(child: Text("About")),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
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

  void _on_item_tapped(int index) {
    setState(() {
      _selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widget_children = [
      Outside_App_List(),
      Icon(Icons.directions_transit),
    ];

    return Scaffold(
      appBar: null,
      body: My_Default_Text_Style(
        child: Center(
          child: widget_children.elementAt(_selected_index),
        ),
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
    var app_rows = variable_controller.outside_app_list
        .map((e) => App_Information_Row(
              an_app: e,
            ))
        .toList();
    // if (app_rows.length == 0) {
    //   app_rows.add(App_Information_Row(
    //     an_app: App_Model(app_name: "yingshaoxo"),
    //   ));
    // }

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
            ? Center(
                child: Text("Loading..."),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: new_rows,
              ),
      ),
    );
  }
}

class App_Information_Row extends StatefulWidget {
  final App_Model an_app;

  const App_Information_Row({super.key, required this.an_app});

  @override
  State<App_Information_Row> createState() => _App_Information_RowState();
}

class _App_Information_RowState extends State<App_Information_Row> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Text(get_sub_string(widget.an_app.app_name ?? "", 0, 45,
                    add_dots: true)),
              )
            ],
          ),
          TextButton(
              onPressed: () async {},
              child: Text(
                "Install",
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    );
  }
}
