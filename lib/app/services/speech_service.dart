import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  /// Initialize once (e.g. when the page opens)
  Future<bool> init() async {
    _ready = await _speech.initialize(
      onStatus: (status) => print('=-=- Speech status: $status'),
      onError: (error) => print('=-=- Speech error: $error'),
    );
    return _ready;
  }

  Future<void> start(void Function(String text) onText) async {
    if (!_ready) {
      // make sure init() was called
      await init();
      if (!_ready) return;
    }
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
      localeId: 'en_US',
      onResult: (SpeechRecognitionResult r) {
        onText(r.recognizedWords);
      },
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
