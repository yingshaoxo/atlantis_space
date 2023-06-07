import 'package:atlantis_space/store/controllers.dart';
import 'package:flutter/material.dart';

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
  List<Widget> widget_children = [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
  ];

  int _selected_index = 0;

  void _on_item_tapped(int index) {
    setState(() {
      _selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
