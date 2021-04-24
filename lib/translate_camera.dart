import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlkit/mlkit.dart';
import 'package:url_launcher/url_launcher.dart';


class TranslateCamera extends StatefulWidget {
  TranslateCamera(this._file);
  final File _file;

  @override
  _TranslateCameraState createState() => new _TranslateCameraState();
}

class _TranslateCameraState extends State<TranslateCamera> {
  FirebaseVisionTextDetector _detector = FirebaseVisionTextDetector.instance;
  List<VisionText> _currentTextLabels = <VisionText>[];

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 1000), () {
      this._analyzeLabels();
    });
  }

  _analyzeLabels() async {
    try {
      var currentTextLabels = await _detector.detectFromPath(widget._file.path);
      setState(() {
        _currentTextLabels = currentTextLabels;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("カメラで翻訳",style: TextStyle(color: Colors.black,fontSize: 30),),
        flexibleSpace: Image(
          image: AssetImage('images/france.png'),
          fit: BoxFit.cover,
        ),
        actions: [
          TextButton(onPressed: () {
            _launchURL();
          },
            child: Text('翻訳する',style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          _buildTextList(_currentTextLabels),
        ],
      ),
    );
  }

  Widget _buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
        flex: 1,
        child: Center(
          child: Text('No text detected',
              style: Theme.of(context).textTheme.subtitle1),
        ),
      );
    }
    // joinのなかで設定できる！！！
    var test = texts.map((text) => text.text).join('\n\n');
    final data11 = ClipboardData(text: '$test');
    Clipboard.setData(data11);
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: texts.length,
          itemBuilder: (context, i) {
            return _buildTextRow(texts[i].text);
          },
        ),
      ),
    );
  }

  Widget _buildTextRow(text) {
    return ListTile(
      title: SelectableText(
        "$text",
      ),
      dense: true,
    );
  }
}
_launchURL() async {
//_launchURL(String test) async {
  // String text = test;
  //var url = 'https://www.deepl.com/ja/translator#en/ja/$text';
  var url = 'https://www.deepl.com/ja/translator#en/ja/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}
