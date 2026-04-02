import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final authTokenProvider =
    StateNotifierProvider<AuthTokenNotifier, AuthToken>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthTokenNotifier(repository: repository);
});

class AuthTokenNotifier extends StateNotifier<AuthToken> {
  final AuthRepository repository;

  AuthTokenNotifier({required this.repository}) : super(const AuthToken());

  Future<String> getToken() async {
    if (state.hasValidToken) {
      return state.accessToken;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: '',
    );

    try {
      final response = await repository.getAuthToken();

      final expiresAt = DateTime.now().add(
        Duration(
          seconds: response.expiresIn > 20
              ? response.expiresIn - 20
              : response.expiresIn,
        ),
      );

      state = state.copyWith(
        accessToken: response.accessToken,
        tokenType: response.tokenType,
        expiresIn: response.expiresIn,
        expiresAt: expiresAt,
        isLoading: false,
        errorMessage: '',
      );

      return state.accessToken;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  void clearToken() {
    state = const AuthToken();
  }
}