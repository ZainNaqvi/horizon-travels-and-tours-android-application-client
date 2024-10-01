class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final bool loadingGoogleAccount;
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.loadingGoogleAccount = false,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    bool? loadingGoogleAccount,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingGoogleAccount: loadingGoogleAccount ?? this.loadingGoogleAccount,
    );
  }
}
