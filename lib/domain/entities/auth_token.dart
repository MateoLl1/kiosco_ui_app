


class AuthToken {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final DateTime? expiresAt;
  final bool isLoading;
  final String errorMessage;

  const AuthToken({
    this.accessToken = '',
    this.tokenType = 'Bearer',
    this.expiresIn = 0,
    this.expiresAt,
    this.isLoading = false,
    this.errorMessage = '',
  });

  bool get hasToken => accessToken.isNotEmpty;

  bool get hasValidToken {
    if (accessToken.isEmpty || expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }

  AuthToken copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    DateTime? expiresAt,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresAt: expiresAt ?? this.expiresAt,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}