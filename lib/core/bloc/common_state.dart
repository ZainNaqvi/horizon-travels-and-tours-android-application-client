import '../../exports.dart';

class CommonState {
  final bool loading;
  final bool actionCompleted;
  final List<Booking> bookings;
  final List<Place> placeDetails;
  final List<String> userInvites;
  final List<Memory> userSharedMemories;
  final List<Memory> userCreatedMemories;

  const CommonState({
    this.loading = false,
    this.actionCompleted = false,
    this.bookings = const [],
    this.placeDetails = const [],
    this.userInvites = const [],
    this.userSharedMemories = const [],
    this.userCreatedMemories = const [],
  });

  CommonState copyWith({
    bool? loading,
    bool? actionCompleted,
    List<Booking>? bookings,
    List<Place>? placeDetails,
    List<String>? userInvites,
    List<Memory>? userSharedMemories,
    List<Memory>? userCreatedMemories,
  }) {
    return CommonState(
      loading: loading ?? this.loading,
      actionCompleted: actionCompleted ?? this.actionCompleted,
      bookings: bookings ?? this.bookings,
      placeDetails: placeDetails ?? this.placeDetails,
      userInvites: userInvites ?? this.userInvites,
      userSharedMemories: userSharedMemories ?? this.userSharedMemories,
      userCreatedMemories: userCreatedMemories ?? this.userCreatedMemories,
    );
  }

  @override
  String toString() {
    return '''
CommonState(
  loading: $loading,
  actionCompleted: $actionCompleted,
  bookings: ${bookings.length},
  placeDetails: ${placeDetails.length},
  userInvites: ${userInvites.length},
  userSharedMemories: ${userSharedMemories.length},
  userCreatedMemories: ${userCreatedMemories.length}
)''';
  }
}
