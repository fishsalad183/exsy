import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:exsy/models/artwork.dart';

class ArtworkRepository {
  Future<List<Artwork>> fetchArtworks() async {
    final List<Artwork> artworks = [];
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where(
          (String key) => key.startsWith('assets/images/artworks/') && isImage(key),
        )
        .toList();

    final String jsonString = await rootBundle.loadString('assets/data/artworks.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    final Map<String, dynamic> artworkDataMap = {for (var item in jsonResponse) item['imageUrl']: item};

    for (int i = 0; i < imagePaths.length; i++) {
      final imagePath = imagePaths[i];
      final artworkData = artworkDataMap[imagePath];

      artworks.add(
        Artwork(
          title: artworkData?['title'] ?? 'Artwork ${i + 1}',
          imageUrl: imagePath,
          description: artworkData?['description'] ?? 'Description of Artwork ${i + 1}',
          dimensions: artworkData?['dimensions'] ?? 'Dimensions of Artwork ${i + 1}',
          year: artworkData?['year'] ?? 2025,
          technique: artworkData?['technique'] ?? 'Technique of Artwork ${i + 1}',
        ),
      );
    }

    return artworks;
  }

  bool isImage(String key) {
    final keyLowerCase = key.toLowerCase();
    return key.startsWith('assets/images/artworks/') &&
        (keyLowerCase.endsWith('.jpg') || keyLowerCase.endsWith('.jpeg') || keyLowerCase.endsWith('.png'));
  }
}
