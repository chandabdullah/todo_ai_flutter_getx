import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TTSService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); // slower = clearer
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
