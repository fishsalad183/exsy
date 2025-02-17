import 'dart:convert';
import 'package:exsy/assets/constants.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:exsy/models/artwork.dart';

class ArtworkRepository {
  Future<List<Artwork>> fetchArtworks() async {
    final List<Artwork> artworks = [];

    // Load the JSON file
    final String jsonString = await rootBundle.loadString('assets/data/artworks.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    // Create a map of artwork data
    final Map<String, dynamic> artworkDataMap = {for (var item in jsonResponse) item['imageUrl']: item};

    // Load the asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Get the list of image paths
    final imagePaths = manifestMap.keys
        .where(
          (String key) => key.startsWith('assets/images/artworks/') && isImage(key),
        )
        .toList();

    // Create artworks based on the JSON data and available images
    for (var imageUrl in artworkDataMap.keys) {
      if (imagePaths.contains(imageUrl)) {
        final artworkData = artworkDataMap[imageUrl];
        artworks.add(
          Artwork(
            title: artworkData['title'] ?? Constants.labelNA,
            imageUrl: imageUrl,
            description: artworkData['description'],
            dimensions: artworkData['dimensions'],
            year: artworkData['year'],
            technique: artworkData['technique'],
          ),
        );
      }
    }

    return artworks;
  }

  bool isImage(String key) {
    final keyLowerCase = key.toLowerCase();
    return key.startsWith('assets/images/artworks/') &&
        (keyLowerCase.endsWith('.jpg') || keyLowerCase.endsWith('.jpeg') || keyLowerCase.endsWith('.png'));
  }
}
