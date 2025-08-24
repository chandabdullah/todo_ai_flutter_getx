import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  Future<bool> initSpeech() async {
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  Future<void> startListening(Function(String text) onResult) async {
    if (_isAvailable) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: "en_US",
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
