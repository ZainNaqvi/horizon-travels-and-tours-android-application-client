// ignore_for_file: use_build_context_synchronously

import 'package:horizon_travel_and_tours_android_application/exports.dart';

class DbHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

// for the provider
  Future<UserCredentials> getUserDetails() async {
    // getting the current user by firebase auth
    User currentUser = _auth.currentUser!;

    //getting the data

    DocumentSnapshot snapshot = await _firebaseFirestore.collection("user").doc(currentUser.uid).get().catchError(
          (onError) {},
        );

    return UserCredentials.fromSnap(snapshot);
  }
  // Creating the function which is responsible for the auth related work

  // creating - the -  function - to - create - the - user
  Future<String> createUser(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required String email,
    required String password,
    required String role,
  }) async {
    String res = "Some error Occured";
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Getting - Response - Firebase - Auth
      UserCredentials userData = UserCredentials(role: role, email: email, uid: userCredential.user!.uid, name: name, imageUrl: imageUrl);
      // Sending - Email -  Verification
      await sendVerification(context);
      // Creating - Firebase - Firestore - Collection (' user ') & Setting - Values
      await _firebaseFirestore.collection("user").doc(userCredential.user!.uid).set(
            userData.toJson(),
          );
      res = "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        showToast("The password provided is too weak.", context);
      } else if (err.code == 'email-already-in-use') {
        showToast("The account already exists for that email.", context);
      } else if (err.code == 'timeout') {
        showToast('The operation has timed out.', context);
      }
    }
    return res;
  }

// Email Verification
  Future<String> sendVerification(BuildContext context) async {
    String res = "Some error occured";
    try {
      _auth.currentUser!.sendEmailVerification();
      showToast(
        "Account created successfully. A verification code has been sent to your email. Please verify your email to log in. Thank you.",
        context,
        toastGravity: ToastGravity.TOP,
      );

      res = "success";
    } on FirebaseException {
      showToast("Some error occured", context);
    }
    return res;
  }

  // login
  Future<String> userLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    String res = "Some error occured.";
    // checking the values are empty or not
    try {
      // now checking and login the user
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await _auth.currentUser!.sendEmailVerification();
        // const url = "https://mail.google.com/";
        // html.window.open(url, "Gmail.com");
        showToast("Please verify the email first.", context);
      } else {
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        showToast("There is no user record corresponding to this identifier", context);
      } else if (err.code == "wrong-password") {
        showToast("Invalid Creaditials", context);
      } else if (err.code == 'timeout') {
        showToast('The operation has timed out.', context);
      } else {
        showToast(err.code, context);
      }
    } catch (err) {
      showToast("Some error occured", context);
    }
    return res;
  }

  // Forgot password
  Future<String> forgotPassword(BuildContext context, {required String email}) async {
    String res = "An error occurred";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast('A password reset email has been sent to your email address.', context);
      res = 'success';
    } on FirebaseException {
      showToast("An error occurred, please try again.", context);
    }
    return res;
  }

  // signout
  Future<String> signOut() async {
    String res = "Some error Occured";
    try {
      await _auth.signOut();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
