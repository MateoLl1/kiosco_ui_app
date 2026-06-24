import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static String nombreApp = dotenv.env['NOMBRE_APP'] ?? '';

  static String ttsUrl =
      dotenv.env['TTS_URL'] ?? 'http://192.168.0.194:8000/tts/';
  static String ttsVoice = dotenv.env['TTS_VOICE'] ?? 'es-EC-AndreaNeural';
  static String ttsRate = dotenv.env['TTS_RATE'] ?? '+0%';
  static String ttsPitch = dotenv.env['TTS_PITCH'] ?? '+0Hz';
}