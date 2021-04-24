import 'package:camera_france_app/translate_camera.dart';
import 'package:camera_france_app/translate_voice.dart';
import 'package:camera_france_app/translate_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'フランス語翻訳アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color: Colors.black,fontSize: 30),),
        flexibleSpace: Image(
          image: AssetImage('images/france.png'),
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //TODO テキストフィールドで翻訳させたい。
            Container(
              width: 300,
              height: 100,
              child: RaisedButton(
                elevation: 16,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TranslateWord()
                    ),
                  );
                },
                child: Text("文字で翻訳",style: TextStyle(fontSize: 25),),),
            ),
            SizedBox(height: 60,),
            //TODO カメラ認識をする
            Container(
              width: 300,
              height: 100,
              child: RaisedButton(
                elevation: 16,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TranslateCamera()
                    ),
                  );
                },
                child: Text("カメラで翻訳",style: TextStyle(fontSize: 25),),),
            ),
            SizedBox(height: 60,),
            //TODO 音声で翻訳
            Container(
              width: 300,
              height: 100,
              child: RaisedButton(
                elevation: 16,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TranslateVoice()
                    ),
                  );
                },
                child: Text("音声で翻訳",style: TextStyle(fontSize: 25),),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
