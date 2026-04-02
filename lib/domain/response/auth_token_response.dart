class AuthTokenResponse {
  final String accessToken;
  final int expiresIn;
  final int refreshExpiresIn;
  final String tokenType;
  final int notBeforePolicy;
  final String scope;

  AuthTokenResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.tokenType,
    required this.notBeforePolicy,
    required this.scope,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    return AuthTokenResponse(
      accessToken: json['access_token']?.toString() ?? '',
      expiresIn: int.tryParse(json['expires_in']?.toString() ?? '0') ?? 0,
      refreshExpiresIn: int.tryParse(json['refresh_expires_in']?.toString() ?? '0') ?? 0,
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      notBeforePolicy: int.tryParse(json['not-before-policy']?.toString() ?? '0') ?? 0,
      scope: json['scope']?.toString() ?? '',
    );
  }
}