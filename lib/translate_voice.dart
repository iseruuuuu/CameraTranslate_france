import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:url_launcher/url_launcher.dart';

//パッケージが日本語対応していない。。。
const languages = const [
  const Language('フランス語', 'fr_FR'),
  //const Language('日本語', 'ja_JP'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class TranslateVoice extends StatefulWidget {
  @override
  _TranslateVoiceState createState() => new _TranslateVoiceState();
}

class _TranslateVoiceState extends State<TranslateVoice> {
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: new AppBar(
        title: new Text('音声で翻訳する',style: TextStyle(color: Colors.black,fontSize: 30),),
        flexibleSpace: Image(
          image: AssetImage('images/france.png'),
          fit: BoxFit.cover,
        ),
        actions: [
          new PopupMenuButton<Language>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          )
        ],
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Expanded(
                  child: new Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey.shade200,
                      child: new Text(transcription))),
              _buildButton(
                onPressed: _speechRecognitionAvailable && !_isListening
                    ? () => start()
                    : null,
                label: _isListening
                    ? '録音中.....'
                    : '録音する (${selectedLang.name})',
              ),
              //キャンセルボタン
              _buildButton(
                onPressed: _isListening ? () => cancel() : null,
                label: 'キャンセル',
              ),

              _buildButton(
                onPressed: _isListening ? () => stop() : null,
                label: 'ストップ',
              ),
              Padding(
                padding: new EdgeInsets.all(12.0),
                child: new RaisedButton(
                  color: Colors.red,
                  onPressed: openTranslate,
                  child: new Text('翻訳する',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: new Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.red,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech
      .listen(locale: selectedLang.code)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();

  void openTranslate() async {
    final data11 = ClipboardData(text: '$transcription');
    Clipboard.setData(data11);
    var url = 'https://www.deepl.com/ja/translator#ja/fr/';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
