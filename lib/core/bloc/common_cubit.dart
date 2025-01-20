import 'dart:developer';

import '../../exports.dart';

class CommonCubit extends Cubit<CommonState> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CommonCubit() : super(const CommonState());

  static const String memoriesCollection = 'memories';
  static const String userCollection = 'user';
  static const String allowedUsersField = 'allowed_user';
  static const String uidField = 'uid';
  static const String invitesField = 'invites';

  /// [Create a booking]
  Future<String> createBooking({
    required String placeId,
    required String placeName,
    required String duration,
    String? bookingType,
    String? roomType,
    bool? includeLunch,
    bool? includeJeepCharges,
    String transportMode = "Van",
    List<String> additionalServices = const [],
    bool privateTrip = false,
  }) async {
    showLoading();
    String result = await DbHelper().createBooking(
      placeId: placeId,
      placeName: placeName,
      duration: duration,
      additionalServices: additionalServices,
      transportMode: transportMode,
      bookingType: bookingType,
      includeJeepCharges: includeJeepCharges,
      includeLunch: includeJeepCharges,
      privateTrip: privateTrip,
      roomType: roomType,
    );
    hideLoading();
    return result;
  }

  /// [Fetch user bookings]
  Future<void> fetchUserBookings() async {
    showLoading();
    try {
      List<Booking> bookings = await DbHelper().fetchUserBookings();

      List<Booking> bookingsWithPlaces = [];

      for (var booking in bookings) {
        Place? place = await DbHelper().getPlaceById(booking.placeId);
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

  /// [Fetch memories]
  Future<List<Memory>> _fetchMemories({
    required String filterField,
    required dynamic filterValue,
  }) async {
    Query query;
    log(filterValue);
    try {
      if (filterField == allowedUsersField) {
        query = _firebaseFirestore.collection(memoriesCollection).where(filterField, arrayContains: filterValue);
      } else {
        query = _firebaseFirestore
            .collection(memoriesCollection)
            .where(
              filterField,
              isEqualTo: filterValue,
            )
            .orderBy('timestamp', descending: true);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) => Memory.fromDocument(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching memories (Field: $filterField, Value: $filterValue): $e');
      return [];
    }
  }

  /// [Fetch shared memories]
  Future<void> fetchSharedMemories() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      emit(state.copyWith(loading: true));
      final memories = await _fetchMemories(filterField: allowedUsersField, filterValue: currentUserId);
      emit(state.copyWith(userSharedMemories: memories, loading: false));
    }
  }

  /// [Fetch memories created by the current user]
  Future<void> fetchCreatedMemories() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      emit(state.copyWith(loading: true));
      final memories = await _fetchMemories(filterField: uidField, filterValue: currentUserId);
      emit(state.copyWith(userCreatedMemories: memories, loading: false));
    }
  }

  /// [Fetch user invites]
  Future<void> fetchUserInvites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        emit(state.copyWith(loading: true));
        final userDoc = await _firebaseFirestore.collection(userCollection).doc(currentUser.uid).get();
        final invites = List<String>.from(userDoc.data()?['invites'] ?? []);
        emit(state.copyWith(userInvites: invites, loading: false));
      } catch (e) {
        debugPrint('Error fetching user invites: $e');
        emit(state.copyWith(userInvites: [], loading: false));
      }
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
