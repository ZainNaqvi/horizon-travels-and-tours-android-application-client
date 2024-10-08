import '../../exports.dart';

class CommonState {
  final bool loading;
  final List<Booking> bookings;
  final List<Place> placeDetails;

  const CommonState({
    this.loading = false,
    this.bookings = const [],
    this.placeDetails = const [],
  });

  CommonState copyWith({
    bool? loading,
    List<Booking>? bookings,
    List<Place>? placeDetails,
  }) {
    return CommonState(
      loading: loading ?? this.loading,
      bookings: bookings ?? this.bookings,
      placeDetails: placeDetails ?? this.placeDetails,
    );
  }

  @override
  String toString() {
    return 'CommonState(loading: $loading, bookings: ${bookings.length}, places: ${placeDetails.length})';
  }
}
