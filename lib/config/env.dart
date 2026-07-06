import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static String nombreApp = dotenv.env['NOMBRE_APP'] ?? '';

  static bool retornoAutomatico =
      dotenv.env['RETORNO_AUTOMATICO']?.toLowerCase() == 'true';
}