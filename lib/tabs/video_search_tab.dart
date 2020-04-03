import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoSearchTab extends StatefulWidget {
  @override
  _VideoSearchTabState createState() => _VideoSearchTabState();
}

class _VideoSearchTabState extends State<VideoSearchTab>
    with AutomaticKeepAliveClientMixin<VideoSearchTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          Center(
            child: Container(
              height: 50,
              width: 120,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image(
                  image: AssetImage('assets/yt_logo.png'),
                ),
              ),
            ),
          ),
          Container(
            child: TextField(
              onSubmitted: (String str) {
                setState(
                  () {
                    if (str != '') {
                      _launchYouTubeSearch(str);
                    }
                  },
                );
              },
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Type a CrossFit exercise name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_launchYouTubeSearch(String exerciseName) async {
  String url = 'https://www.youtube.com/results?search_query=$exerciseName';
  if (exerciseName.toLowerCase().contains('crossfit') == false) {
    url += '+crossfit';
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
