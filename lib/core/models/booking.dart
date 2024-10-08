import '../../exports.dart';

class Booking {
  final String userId;
  final String placeId;
  final String placeName;
  final String duration;
  final DateTime createdAt;
  final String status;
  final Place? placeDetails;

  Booking({
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.duration,
    required this.createdAt,
    required this.status,
    this.placeDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
      'placeName': placeName,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['userId'],
      placeId: json['placeId'],
      placeName: json['placeName'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      placeDetails: json['placeDetails'] != null ? Place.fromJson(json['placeDetails']) : null,
    );
  }

  // CopyWith method
  Booking copyWith({
    String? userId,
    String? placeId,
    String? placeName,
    String? duration,
    DateTime? createdAt,
    String? status,
    Place? placeDetails,
  }) {
    return Booking(
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      placeDetails: placeDetails ?? this.placeDetails,
    );
  }
}
