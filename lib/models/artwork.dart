class Artwork {
  final String title;
  final String imageUrl;
  final String? description;
  final String? dimensions;
  final int? year;
  final String? technique;

  Artwork({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.dimensions,
    required this.year,
    required this.technique,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      title: json['title'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      dimensions: json['dimensions'],
      year: json['year'],
      technique: json['technique'],
    );
  }
}
