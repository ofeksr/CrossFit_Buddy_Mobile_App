import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:photo_view/photo_view.dart';
import 'dart:io';

bool changedWOD;
TextEditingController myController = new TextEditingController();

class WorkoutRoutineTab extends StatefulWidget {
  @override
  _WorkoutRoutineTabState createState() => _WorkoutRoutineTabState();
}

class _WorkoutRoutineTabState extends State<WorkoutRoutineTab>
    with AutomaticKeepAliveClientMixin<WorkoutRoutineTab> {
  @override
  bool get wantKeepAlive => true;

  void initState() {
    myController.addListener(() {
      final text = myController.text.toLowerCase();
      myController.value = myController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  File _pickedImage;

  Future _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select the image source"),
        actions: <Widget>[
          MaterialButton(
            child: Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          )
        ],
      ),
    );

    if (imageSource != null) {
      var image = await ImagePicker.pickImage(source: imageSource);
      if (image != null) {
        setState(() => _pickedImage = image);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('WOD Browser', style: TextStyle(fontSize: 15)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black)),
                  onPressed: () async {
                    bool differentWODSelected =
                        await _wodBrowserCheckWODSelectChanged(context);
                    setState(
                      () => {
                        differentWODSelected == true
                            ? _pickedImage = null
                            : null
                      },
                    );
                  },
                ),
                RaisedButton(
                  onPressed: _pickImage,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black)),
                  child: Text('Load workout routine image',
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
            Expanded(
              child: _pickedImage == null
                  ? _typeRoutineBox(context)
                  : ClipRect(
                      child: _buildImageWidgetByOrientation(
                          context, _pickedImage)),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImageWidgetByOrientation(BuildContext context, pickedImage) {
  final image = new PhotoView(
//    imageProvider: AssetImage(FileImage(pickedImage).file.path.toString()),
    imageProvider: new FileImage(pickedImage),
    minScale: PhotoViewComputedScale.contained * 0.8,
    maxScale: PhotoViewComputedScale.covered * 1.8,
    basePosition: Alignment.center,
    initialScale: PhotoViewComputedScale.covered,
    backgroundDecoration: const BoxDecoration(
      color: Colors.white,
    ),
  );
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: image,
    );
  } else {
    return image;
  }
}

//TextEditingController myController = new TextEditingController();

_typeRoutineBox(BuildContext context) {
  return TextField(
    controller: myController,
    textAlign: TextAlign.center,
    cursorColor: Colors.black,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    decoration: InputDecoration(
      hintText: 'Type (or paste!) your workout routine',
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
  );
}

Future<bool> _wodBrowserCheckWODSelectChanged(BuildContext context) async {
  await _wodBrowserListDialog(context);
  if (changedWOD && changedWOD != false) {
    return true;
  } else {
    return false;
  }
}

_wodBrowserListDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select WOD'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
        content: FutureBuilder(
          future: _loadWODSAsset(),
          builder: (context, futureWODSRoutines) {
            if (futureWODSRoutines.hasData) {
              final List allWODS = futureWODSRoutines.data;
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allWODS.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _wodRoutineDialog(
                        context,
                        _getWODName(allWODS, index),
                        _getWODRoutine(allWODS, index),
                      ),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(_getWODName(allWODS, index)),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]),
                backgroundColor: Colors.black,
              );
            }
          },
        ),
      );
    },
  );
}

_wodRoutineDialog(BuildContext context, String wodName, String wodRoutine) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(wodName),
        content: Text(wodRoutine),
        actions: [
          FlatButton(
            onPressed: () => {changedWOD = true, Navigator.pop(context)},
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () => {
              changedWOD = true,
              myController.value = TextEditingValue(text: wodRoutine),
              Navigator.pop(context),
              Navigator.pop(context),
            },
            child: Text('Select'),
          ),
        ],
      );
    },
  );
}

Stream<int> countStream(int to) async* {
  for (int i = 0; i <= to; i++) {
    yield i;
  }
}

Future<List> _loadWODSAsset() async {
  var wodsList = List();
  var stream = countStream(9); // 9 WODS txt files in assets dir
  await for (var i in stream) {
    final wod = await rootBundle.loadString('assets/wods/wod_$i.txt');
    wodsList.add(wod);
  }
  return wodsList;
}

String _getWODName(List allWODS, int index) {
  return allWODS[index].split('\n')[0].split(', ')[0];
}

String _getWODRoutine(List allWODS, int index) {
  return allWODS[index].split('\n').sublist(1).join('\n');
}
