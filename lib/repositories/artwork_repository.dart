import 'package:exsy/models/artwork.dart';

class ArtworkRepository {
  Future<List<Artwork>> fetchArtworks() async {
    return [
      Artwork(
        title: 'Artwork 1',
        imageUrl: 'assets/images/img1.jpg',
        description: 'Description of Artwork 1',
      ),
      Artwork(
        title: 'Artwork 2',
        imageUrl: 'assets/images/img2.jpg',
        description: 'Description of Artwork 2',
      ),
      Artwork(
        title: 'Artwork 3',
        imageUrl: 'assets/images/img3.jpg',
        description: 'Description of Artwork 3',
      ),
      Artwork(
        title: 'Artwork 4',
        imageUrl: 'assets/images/img4.jpg',
        description: 'Description of Artwork 4',
      ),
      Artwork(
        title: 'Artwork 5',
        imageUrl: 'assets/images/img5.jpg',
        description: 'Description of Artwork 5',
      ),
      Artwork(
        title: 'Artwork 6',
        imageUrl: 'assets/images/img6.jpg',
        description: 'Description of Artwork 6',
      ),
    ];
  }
}
