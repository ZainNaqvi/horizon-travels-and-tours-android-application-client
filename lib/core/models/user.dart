import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredentials {
  final String? name;
  final String? email;
  final String? uid;
  final String? role;
  final String? imageUrl;

  // final List cart;
  UserCredentials({
    required this.name,
    required this.email,
    required this.uid,
    required this.role,
    required this.imageUrl,
  });

  // Converts the object to a map (JSON)
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
        'role': role,
        'imageUrl': imageUrl,
      };

  // Converts a Firestore document snapshot to a UserCredentials object
  static UserCredentials fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return UserCredentials(
      name: snapshot['name'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      role: snapshot['role'],
      imageUrl: snapshot['imageUrl'],
    );
  }
}
