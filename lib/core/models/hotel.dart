class Hotel {
  final String docId;
  final String title;
  final List<Showcase> showcases;

  Hotel({
    required this.docId,
    required this.title,
    required this.showcases,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    var showcaseList = json['showcase'] as List<dynamic>;
    List<Showcase> showcases = showcaseList.map((showcase) => Showcase.fromJson(showcase as Map<String, dynamic>)).toList();

    return Hotel(
      docId: json['docId'] as String,
      title: json['title'] as String,
      showcases: showcases,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'title': title,
      'showcase': showcases.map((showcase) => showcase.toJson()).toList(),
    };
  }
}

class Showcase {
  final String imageUrl;
  final String title;

  Showcase({
    required this.imageUrl,
    required this.title,
  });

  factory Showcase.fromJson(Map<String, dynamic> json) {
    return Showcase(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
    };
  }
}
