import '../../../exports.dart';

class FindTourCubit extends Cubit<FindTourState> {
  FindTourCubit() : super(const FindTourState());

  void fetchPlaces() async {
    try {
      emit(state.copyWith(isLoading: true));

      final snapshot = await FirebaseFirestore.instance.collection('places').get();
      final places = snapshot.docs.map((doc) => Place.fromJson(doc.data())).toList();

      emit(state.copyWith(isLoading: false, places: places));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  void changeSelectedDuration(int index) {
    emit(state.copyWith(selectedDurationIndex: index));
  }

  void selectPlan(int index) {
    emit(state.copyWith(selectedPlan: index));
  }

  void changeSelectedIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
