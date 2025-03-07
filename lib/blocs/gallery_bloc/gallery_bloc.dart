import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exsy/models/artwork.dart';
import 'package:exsy/models/album.dart';
import 'package:exsy/repositories/artwork_repository.dart';
import 'package:exsy/repositories/album_repository.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ArtworkRepository artworkRepository;
  final AlbumRepository albumRepository;

  GalleryBloc(this.artworkRepository, this.albumRepository) : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
  }

  Future<void> _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    try {
      final artworks = await artworkRepository.fetchArtworks();
      final albums = await albumRepository.fetchAlbums();
      emit(GalleryLoaded(artworks, albums));
    } catch (_) {
      emit(GalleryError());
    }
  }
}
