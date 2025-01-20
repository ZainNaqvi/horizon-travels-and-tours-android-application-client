import '../../exports.dart';

class Booking {
  final String userId;
  final String placeId;
  final String placeName;
  final String duration;
  final DateTime createdAt;
  final String status;
  final Place? placeDetails;

  final String roomType;
  final bool includeLunch;
  final bool includeJeepCharges;
  final String transportMode;
  final List<String> additionalServices;
  final bool privateTrip;

  Booking({
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.duration,
    required this.createdAt,
    required this.status,
    this.placeDetails,
    required this.roomType,
    required this.includeLunch,
    required this.includeJeepCharges,
    required this.transportMode,
    required this.additionalServices,
    required this.privateTrip,
  });

  // Convert Booking to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
      'placeName': placeName,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'roomType': roomType,
      'includeLunch': includeLunch,
      'includeJeepCharges': includeJeepCharges,
      'transportMode': transportMode,
      'additionalServices': additionalServices,
      'privateTrip': privateTrip,
      'placeDetails': placeDetails?.toJson(),
    };
  }

  // Create Booking from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['userId'],
      placeId: json['placeId'],
      placeName: json['placeName'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      placeDetails: json['placeDetails'] != null ? Place.fromJson(json['placeDetails']) : null,
      roomType: json['roomType'],
      includeLunch: json['includeLunch'],
      includeJeepCharges: json['includeJeepCharges'],
      transportMode: json['transportMode'],
      additionalServices: List<String>.from(json['additionalServices']),
      privateTrip: json['privateTrip'],
    );
  }

  // CopyWith method for immutability
  Booking copyWith({
    String? userId,
    String? placeId,
    String? placeName,
    String? duration,
    DateTime? createdAt,
    String? status,
    Place? placeDetails,
    String? roomType,
    bool? includeLunch,
    bool? includeJeepCharges,
    String? transportMode,
    List<String>? additionalServices,
    bool? privateTrip,
  }) {
    return Booking(
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      placeDetails: placeDetails ?? this.placeDetails,
      roomType: roomType ?? this.roomType,
      includeLunch: includeLunch ?? this.includeLunch,
      includeJeepCharges: includeJeepCharges ?? this.includeJeepCharges,
      transportMode: transportMode ?? this.transportMode,
      additionalServices: additionalServices ?? this.additionalServices,
      privateTrip: privateTrip ?? this.privateTrip,
    );
  }
}
