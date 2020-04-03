import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen/screen.dart';
import 'tabs/video_search_tab.dart';
import 'tabs/workout_routine_tab.dart';
import 'tabs/timer_tab.dart';
import 'dart:math';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

bool mainScreenStayAwake;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _getSystemAwakePrefs();
      _getTimerAwakePrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: MaterialApp(
          home: Scaffold(
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: _getRandomQuoteImageFromAssets(),
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                  ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: Text('Settings Menu'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close'),
                                ),
                              ],
                              content: Container(
                                width: 250,
                                height: 150,
                                child:
                                ListView(shrinkWrap: true, children: <Widget>[
                                  Center(
                                    child: Text(
                                      'Screen stay awake policy',
                                      style: TextStyle(fontWeight: FontWeight
                                          .bold),
                                    ),
                                  ),
                                  Card(
                                    child: TimerRunningScreenAwakeSwitch(),
                                  ),
                                  Card(
                                    child: AlwaysKeepScreenAwakeSwitch(),
                                  ),
                                ]),
                              ),
                            ),
                      );
                    },
                  ),
                  ListTile(
                      title: Text('About'),
                      leading: Icon(Icons.android),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              AboutDialog(
                                applicationName: 'CrossFit Buddy',
                                applicationLegalese: 'https://github.com/ofeksr',
                            applicationVersion: '0.6.0',
                                children: <Widget>[
                                  FlutterLogo(
                                    colors: Colors.red,
                                    size: 105,
                                    style: FlutterLogoStyle.horizontal,
                                  )
                                ],
                              ),
                        );
                      }),
                ],
              ),
            ),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: HexColor('970000'),
              elevation: 0,
              title: Text(
                'CrossFit Buddy',
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              bottom: TabBar(
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black),
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Workout\nRoutine",
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Timer", textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Video\nSearch",
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ]),
            ),
            body: SafeArea(
              child: TabBarView(
                children: [
                  WorkoutRoutineTab(),
                  TimerTab(),
                  VideoSearchTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

_getRandomQuoteImageFromAssets() {
  AssetImage quote;
  var random = new Random();
  int randomNumber = random.nextInt(6); // 9 Quotes files in assets dir
  quote = AssetImage('assets/quotes/$randomNumber.jpg');
  return Image(image: quote);
}

class TimerRunningScreenAwakeSwitch extends StatefulWidget {
  @override
  _TimerRunningScreenAwakeSwitchState createState() =>
      new _TimerRunningScreenAwakeSwitchState();
}

class _TimerRunningScreenAwakeSwitchState
    extends State<TimerRunningScreenAwakeSwitch> {
  bool _v = getTimerRunsAwakeState();

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('when Timer is running only'),
      value: _v,
      onChanged: (value) =>
          setState(
                () {
              _v = value;
              if (_v) {
                setTimerRunsAwakeState(true);
                mainScreenStayAwake = false;

                _saveSystemAwakePrefs(false);
                _saveTimerAwakePrefs(true);
              } else {
                setTimerRunsAwakeState(false);

                _saveTimerAwakePrefs(false);
              }
            },
          ),
    );
  }
}

class AlwaysKeepScreenAwakeSwitch extends StatefulWidget {
  @override
  _AlwaysKeepScreenAwakeSwitchState createState() =>
      new _AlwaysKeepScreenAwakeSwitchState();
}

class _AlwaysKeepScreenAwakeSwitchState
    extends State<AlwaysKeepScreenAwakeSwitch> {
  bool _v = mainScreenStayAwake;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Always'),
      value: _v,
      onChanged: (value) =>
          setState(
                () {
              _v = value;
              if (_v) {
                Screen.keepOn(true);
                mainScreenStayAwake = true;
                setTimerRunsAwakeState(false);

                _saveSystemAwakePrefs(true);
                _saveTimerAwakePrefs(false);
              } else {
                mainScreenStayAwake = false;

                _saveSystemAwakePrefs(false);
              }
            },
          ),
    );
  }
}

_saveSystemAwakePrefs(bool awakeState) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('always_awake_state', awakeState);
}

_saveTimerAwakePrefs(bool awakeState) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('timer_run_awake_state', awakeState);
}

_getTimerAwakePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final userAwakePrefs = prefs.getBool('timer_run_awake_state') ?? true;
  screenAwakeStateRunningOnly = userAwakePrefs;
}

_getSystemAwakePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final userAwakePrefs = prefs.getBool('always_awake_state') ?? false;
  mainScreenStayAwake = userAwakePrefs;
}
