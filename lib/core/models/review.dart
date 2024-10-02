class Review {
  final String docId;
  final String placeId;
  final String review;
  final String title;
  final String user;

  Review({
    required this.docId,
    required this.placeId,
    required this.review,
    required this.title,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      docId: json['docId'] as String,
      placeId: json['placeId'] as String,
      review: json['review'] as String,
      title: json['title'] as String,
      user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'placeId': placeId,
      'review': review,
      'title': title,
      'user': user,
    };
  }
}
