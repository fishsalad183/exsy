class Album {
  final String title;
  final List<String> imageUrls;
  final String? description;

  Album({
    required this.title,
    required this.imageUrls,
    this.description,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      imageUrls: List<String>.from(json['imageUrls']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrls': imageUrls,
      'description': description,
    };
  }
}
