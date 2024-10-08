class CommonState {
  final bool loading;

  const CommonState({this.loading = false});

  CommonState copyWith({bool? loading}) {
    return CommonState(
      loading: loading ?? this.loading,
    );
  }
}
