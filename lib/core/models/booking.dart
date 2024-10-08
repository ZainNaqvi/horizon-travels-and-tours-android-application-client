class Booking {
  final String userId;
  final String placeId;
  final String placeName;
  final String duration;
  final DateTime createdAt;
  final String status;

  Booking({
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.duration,
    required this.createdAt,
    required this.status,
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
    );
  }
}
