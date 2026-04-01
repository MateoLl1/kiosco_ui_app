import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static String nombreApp = dotenv.env['NOMBRE_APP'] ?? '';
  static String autoconsaApiBaseUrl = dotenv.env['AUTOCONSA_API_BASE_URL'] ?? '';
  static String authBaseUrl = dotenv.env['AUTH_BASE_URL'] ?? '';
  static String authClientId = dotenv.env['AUTH_CLIENT_ID'] ?? '';
  static String authClientSecret = dotenv.env['AUTH_CLIENT_SECRET'] ?? '';
  static String authGrantType = dotenv.env['AUTH_GRANT_TYPE'] ?? 'client_credentials';
  static String empresaDefault = dotenv.env['EMPRESA_DEFAULT'] ?? '1';
}