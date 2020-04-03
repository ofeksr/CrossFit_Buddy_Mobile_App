import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:screen/screen.dart';

bool isActive = false;
int roundsCounter = 0;
List<bool> isSelected = [false, true, false, false];

bool screenAwakeStateRunningOnly;

class TimerTab extends StatefulWidget {
  @override
  _TimerTabState createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab>
    with AutomaticKeepAliveClientMixin<TimerTab> {
  @override
  bool get wantKeepAlive => true;

  static const duration = const Duration(seconds: 1);
  int secondPassed = 0;

  bool isSelected = false;

  Timer timer;

  void handleTick() {
    if (isActive) {
      setState(() {
        secondPassed = secondPassed + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });

    int seconds = secondPassed % 60;
    int minutes = secondPassed ~/ 60;
    int hours = secondPassed ~/ (60 * 60);

    return OrientationBuilder(builder: (context, orientation) {
      return Center(
        child: orientation == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _clock(hours, minutes, seconds),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: 160, // specific value
                            height: 60,
                            child: RaisedButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.green)),
                              child: Text(
                                isActive ? 'STOP' : 'START',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              textColor: Colors.white70,
                              onPressed: () {
                                setState(() {
                                  isActive = !isActive;
                                });
                                if (isActive && screenAwakeStateRunningOnly) {
                                  Screen.keepOn(true);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160, // specific value
                            height: 60,
                            child: RaisedButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.red)),
                              child: Text(
                                'RESET',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.red,
                              textColor: Colors.white70,
                              onPressed: () {
                                roundsCounter = 0;
                                if (screenAwakeStateRunningOnly) {
                                  Screen.keepOn(false);
                                }
                                setState(
                                  () {
                                    isActive = false;
                                    secondPassed = 0;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                  Divider(thickness: 1.2),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue[900], // button color
                          child: InkWell(
                            splashColor: Colors.white70, // inkwell color
                            child: SizedBox(
                              width: 86,
                              height: 86,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: 200),
                                      child: Text('$roundsCounter'),
                                      textAlign: TextAlign.center,
                                      style: isSelected
                                          ? TextStyle(
                                          fontSize: 48,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)
                                          : TextStyle(
                                          fontSize: 32,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Icon(
                                      Icons.plus_one,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (isActive) {
                                roundsCounter++;
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Rounds',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue[900], // button color
                          child: InkWell(
                            splashColor: Colors.white70, // inkwell color
                            child: SizedBox(
                              width: 86,
                              height: 86,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: 200),
                                      child: Text('$roundsCounter'),
                                      textAlign: TextAlign.center,
                                      style: isSelected
                                          ? TextStyle(
                                              fontSize: 48,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)
                                          : TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Icon(
                                      Icons.plus_one,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (isActive) {
                                roundsCounter++;
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Rounds',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    thickness: 1.2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _clock(hours, minutes, seconds),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 160, // specific value
                                height: 60,
                                child: RaisedButton(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.green)),
                                  child: Text(
                                    isActive ? 'STOP' : 'START',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Colors.green,
                                  textColor: Colors.white70,
                                  onPressed: () {
                                    setState(() {
                                      isActive = !isActive;
                                    });
                                    if (isActive &&
                                        screenAwakeStateRunningOnly) {
                                      Screen.keepOn(true);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 160, // specific value
                                height: 60,
                                child: RaisedButton(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.red)),
                                  child: Text(
                                    'RESET',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Colors.red,
                                  textColor: Colors.white70,
                                  onPressed: () {
                                    roundsCounter = 0;
                                    if (screenAwakeStateRunningOnly) {
                                      Screen.keepOn(false);
                                    }
                                    setState(
                                      () {
                                        isActive = false;
                                        secondPassed = 0;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
      );
    });
  }
}

//Widget _buildToggleButtons() {
//  return ToggleButtons(
//    isSelected: isSelected,
//    fillColor: Colors.red[900],
//    color: Colors.black54,
//    selectedColor: Colors.black,
//    borderRadius: BorderRadius.circular(30),
//    borderWidth: 5,
//    borderColor: Colors.black26,
//    selectedBorderColor: Colors.black,
//    children: <Widget>[
//      Text('AMRAP', style: TextStyle(fontWeight: FontWeight.bold)),
//      Text('ForTime', style: TextStyle(fontWeight: FontWeight.bold)),
//      Text('EMOM', style: TextStyle(fontWeight: FontWeight.bold)),
//      Text('TABATA', style: TextStyle(fontWeight: FontWeight.bold)),
//    ],
//    onPressed: (int index) {
//      setState(() {
//        for (int buttonIndex = 0;
//            buttonIndex < isSelected.length;
//            buttonIndex++) {
//          if (buttonIndex == index) {
//            isSelected[buttonIndex] = true;
//          } else {
//            isSelected[buttonIndex] = false;
//          }
//        }
//      });
//    },
//  );
//}

class CustomTextContainer extends StatelessWidget {
  CustomTextContainer({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(65),
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label == null ? '' : '$label',
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

Widget _clock(hours, minutes, seconds) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CustomTextContainer(
        label: 'HRS',
        value: hours.toString().padLeft(2, '0'),
      ),
      CustomTextContainer(
        label: 'MIN',
        value: minutes.toString().padLeft(2, '0'),
      ),
      CustomTextContainer(
        label: 'SEC',
        value: seconds.toString().padLeft(2, '0'),
      ),
    ],
  );
}

getTimerRunsAwakeState() {
  return screenAwakeStateRunningOnly;
}

setTimerRunsAwakeState(bool newScreenAwakeState) {
  screenAwakeStateRunningOnly = newScreenAwakeState;
}
