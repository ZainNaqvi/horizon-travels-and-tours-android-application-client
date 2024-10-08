import '../../../exports.dart';

class FindTourState {
  final bool isLoading;
  final List<Place> places;
  final String? error;
  final int selectedIndex;
  final int selectedDurationIndex;
  final int? selectedPlan;

  const FindTourState({
    this.isLoading = true,
    this.places = const [],
    this.error,
    this.selectedIndex = 0,
    this.selectedDurationIndex = 0,
    this.selectedPlan,
  });

  FindTourState copyWith({
    bool? isLoading,
    List<Place>? places,
    String? error,
    int? selectedIndex,
    int? selectedDurationIndex,
    int? selectedPlan,
  }) {
    return FindTourState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      error: error ?? this.error,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedDurationIndex: selectedDurationIndex ?? this.selectedDurationIndex,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}
