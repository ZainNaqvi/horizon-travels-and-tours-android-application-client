import 'dart:developer';
import '../../exports.dart';

class DbHelper {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// [Firebase collections]
  static const _userCollection = "user";
  static const _bookingCollection = "booking";
  static const _placesCollection = "places";

  /// [Fetch user details]
  Future<UserCredentials> fetchUserDetails() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user is currently logged in");

      final snapshot = await _firestore.collection(_userCollection).doc(currentUser.uid).get();
      return UserCredentials.fromSnap(snapshot);
    } catch (e) {
      log("Error fetching user details: $e");
      rethrow;
    }
  }

  /// [Create a new user]
  Future<String> createUser({
    required BuildContext context,
    required String name,
    required String imageUrl,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userData = UserCredentials(
        role: role,
        email: email,
        uid: userCredential.user!.uid,
        name: name,
        imageUrl: imageUrl,
      );

      await sendVerificationEmail(context);
      await _firestore.collection(_userCollection).doc(userCredential.user!.uid).set(userData.toJson());
      return "success";
    } on FirebaseAuthException catch (err) {
      return handleFirebaseAuthError(err, context);
    } catch (e) {
      log("Error creating user: $e");
      return "An unexpected error occurred.";
    }
  }

  /// [Send email verification]
  Future<void> sendVerificationEmail(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showToast(
        "Verification email sent. Please check your email to verify your account.",
        context,
        toastGravity: ToastGravity.TOP,
      );
    } catch (e) {
      log("Error sending email verification: $e");
      showToast("Failed to send verification email.", context);
    }
  }

  /// [Login user]
  Future<String> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendVerificationEmail(context);
        return "Email not verified. Verification email sent.";
      }
      return "success";
    } on FirebaseAuthException catch (err) {
      return handleFirebaseAuthError(err, context);
    } catch (e) {
      log("Error logging in user: $e");
      return "An unexpected error occurred.";
    }
  }

  /// [Forgot password]
  Future<void> forgotPassword({required BuildContext context, required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast('Password reset email sent.', context);
    } catch (e) {
      log("Error resetting password: $e");
      showToast("Failed to send password reset email.", context);
    }
  }

  /// [Sign in with Google]
  Future<String> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Google sign-in canceled");

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final userData = UserCredentials(
        role: 'user',
        email: userCredential.user?.email ?? '',
        uid: userCredential.user!.uid,
        name: userCredential.user?.displayName ?? '',
        imageUrl: userCredential.user?.photoURL ?? '',
      );

      await _firestore.collection(_userCollection).doc(userCredential.user!.uid).set(userData.toJson());
      return "success";
    } catch (e) {
      log("Error signing in with Google: $e");
      return "Failed to sign in with Google.";
    }
  }

  /// [Create a booking]
  Future<String> createBooking({
    required String placeId,
    required String placeName,
    required String duration,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return "User not logged in";

      final booking = Booking(
        userId: currentUser.uid,
        placeId: placeId,
        placeName: placeName,
        duration: duration,
        createdAt: DateTime.now(),
        status: 'Pending',
      );

      await _firestore.collection(_bookingCollection).add(booking.toJson());
      return "Booking request submitted successfully.";
    } catch (e) {
      log("Error creating booking: $e");
      return "Failed to create booking.";
    }
  }

  /// [Get place by ID]
  Future<Place?> getPlaceById(String placeId) async {
    try {
      final snapshot = await _firestore.collection(_placesCollection).doc(placeId).get();
      if (!snapshot.exists) {
        return null; // Place not found
      }
      return Place.fromJson(snapshot.data()!);
    } catch (e) {
      log("Error fetching place by ID: $e");
      return null;
    }
  }

  /// [Fetch user bookings]
  Future<List<Booking>> fetchUserBookings() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      final snapshot = await _firestore.collection(_bookingCollection).where("userId", isEqualTo: currentUser.uid).get();

      return snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
    } catch (e) {
      log("Error fetching user bookings: $e");
      return [];
    }
  }

  /// [Handle Firebase Auth errors]
  String handleFirebaseAuthError(FirebaseAuthException err, BuildContext context) {
    final errorMessages = {
      'user-not-found': "No user found with this email.",
      'wrong-password': "Incorrect password.",
      'weak-password': "The password provided is too weak.",
      'email-already-in-use': "An account already exists with this email.",
    };
    final message = errorMessages[err.code] ?? "An error occurred.";
    showToast(message, context);
    return message;
  }
}
