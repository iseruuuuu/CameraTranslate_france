import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslateWord extends StatefulWidget {

  @override
  _TranslateWordState createState() => _TranslateWordState();
}

class _TranslateWordState extends State<TranslateWord> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文字で翻訳',style: TextStyle(color: Colors.black,fontSize: 30),),
        flexibleSpace: Image(
          image: AssetImage('images/france.png'),
          fit: BoxFit.cover,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            // 余白を付ける
            padding: EdgeInsets.only(top: 50, left: 30,right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 8,),
                //TODO 他を押すとtextfieldを閉じるようにする
                // テキスト入力
                Container(
                  height: 300,
                  color: Color(0xffeeeeee),
                  padding: EdgeInsets.all(10.0),
                  child: new ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200.0,
                    ),
                    child: new Scrollbar(
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: SizedBox(
                          height: 190.0,
                          child: TextField(
                            maxLines: 10,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _text  = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Container(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    elevation: 16,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: openTranslate,
                    child: Text("翻訳する",style: TextStyle(fontSize: 20),),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openTranslate() async {
    final data11 = ClipboardData(text: '$_text');
    Clipboard.setData(data11);
    var url = 'https://www.deepl.com/ja/translator#ja/fr/';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
