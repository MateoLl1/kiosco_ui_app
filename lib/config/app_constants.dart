class AppBreakpoints {
  static const double wide = 900.0;
}

class AppDurations {
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 10);
  static const Duration ttsReceiveTimeout = Duration(seconds: 30);

  static const Duration overlayDisplay = Duration(seconds: 8);
  static const Duration screenRefresh = Duration(seconds: 5);
  static const Duration welcomeRedirect = Duration(seconds: 3);

  static const Duration kioskIdle = Duration(seconds: 10);
  static const Duration kioskIdleTurno = Duration(seconds: 15);
}
