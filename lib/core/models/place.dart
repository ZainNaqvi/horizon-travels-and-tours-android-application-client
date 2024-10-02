class Place {
  final String docId;
  final String description;
  final List<String> duration;
  final String hotels;
  final String imageUrl;
  final String rating;
  final String reviews;
  final List<String> subLocation;
  final String title;

  Place({
    required this.docId,
    required this.description,
    required this.duration,
    required this.hotels,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.subLocation,
    required this.title,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      docId: json['docId'] as String,
      description: json['description'] as String,
      duration: List<String>.from(json['duration']),
      hotels: json['hotels'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: json['rating'] as String,
      reviews: json['reviews'] as String,
      subLocation: List<String>.from(json['sub_location']),
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'description': description,
      'duration': duration,
      'hotels': hotels,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'sub_location': subLocation,
      'title': title,
    };
  }
}
