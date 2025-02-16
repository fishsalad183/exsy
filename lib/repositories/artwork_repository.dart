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
          (String key) => key.startsWith('assets/images/artworks/') && (key.endsWith('.jpg') || key.endsWith('.png')),
        )
        .toList();

    for (int i = 0; i < imagePaths.length; i++) {
      final imagePath = imagePaths[i];
      artworks.add(
        Artwork(
          title: 'Artwork ${i + 1}',
          imageUrl: imagePath,
          description: 'Description of Artwork ${i + 1}',
        ),
      );
    }

    return artworks;
  }
}
