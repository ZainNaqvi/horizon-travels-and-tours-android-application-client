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

  Future<void> fetchUserBookings() async {
    showLoading();
    try {
      List<Booking> bookings = await _dbHelper.getUserBookingDetails();

      List<Booking> bookingsWithPlaces = [];

      for (var booking in bookings) {
        Place? place = await _dbHelper.getPlaceById(booking.placeId);
        bookingsWithPlaces.add(
          booking.copyWith(placeDetails: place),
        );
      }

      emit(state.copyWith(bookings: bookingsWithPlaces));
    } catch (e) {
      debugPrint("Error fetching user bookings: $e");
      emit(state.copyWith(bookings: []));
    } finally {
      hideLoading();
    }
  }

  void isActionCompleted(bool isActionCompleted) {
    emit(state.copyWith(actionCompleted: isActionCompleted));
  }

  void showLoading() {
    emit(state.copyWith(loading: true));
  }

  void hideLoading() {
    emit(state.copyWith(loading: false));
  }
}
