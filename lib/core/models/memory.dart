import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  final String id;
  final List<String> allowedUsers;
  final List<String> imageLinks;
  final bool canGetScreenshot;
  final bool canGetVideoRecording;
  final bool restricted;
  final String uid;
  final Timestamp timestamp;
  final String viewStart;
  final String viewEnd;

  Memory({
    required this.id,
    required this.allowedUsers,
    required this.imageLinks,
    required this.canGetScreenshot,
    required this.canGetVideoRecording,
    required this.restricted,
    required this.uid,
    required this.timestamp,
    required this.viewStart,
    required this.viewEnd,
  });

  factory Memory.fromDocument(DocumentSnapshot doc) {
    return Memory(
      id: doc.id,
      allowedUsers: List<String>.from(doc['allowed_users'] ?? []),
      imageLinks: List<String>.from(doc['imageLinks'] ?? []),
      canGetScreenshot: doc['canGetScreenshot'] ?? false,
      canGetVideoRecording: doc['canGetVideoRecording'] ?? false,
      restricted: doc['restricted'] ?? true,
      uid: doc['uid'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.now(),
      viewStart: doc['viewStart'] ?? '',
      viewEnd: doc['viewEnd'] ?? '',
    );
  }
}
