import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:exsy/models/album.dart';

class AlbumRepository {
  Future<List<Album>> fetchAlbums() async {
    final String jsonString = await rootBundle.loadString('assets/data/albums.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    return jsonResponse.map((json) => Album.fromJson(json)).toList();
  }
}
