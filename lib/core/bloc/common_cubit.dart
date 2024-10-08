import '../../exports.dart';

class CommonCubit extends Cubit<CommonState> {
  final DbHelper _dbHelper;

  CommonCubit(this._dbHelper) : super(const CommonState());

  Future<String> createBooking({
    required String placeId,
    required String placeName,
    required String duration,
  }) async {
    showLoading();
    String result = await _dbHelper.createBooking(
      placeId: placeId,
      placeName: placeName,
      duration: duration,
    );
    hideLoading();
    return result;
  }

  void showLoading() {
    emit(state.copyWith(loading: true));
  }

  void hideLoading() {
    emit(state.copyWith(loading: false));
  }
}
