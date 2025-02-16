import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exsy/models/artwork.dart';
import 'package:exsy/repositories/artwork_repository.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ArtworkRepository artworkRepository;

  GalleryBloc(this.artworkRepository) : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
  }

  Future<void> _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    try {
      final artworks = await artworkRepository.fetchArtworks();
      emit(GalleryLoaded(artworks));
    } catch (_) {
      emit(GalleryError());
    }
  }
}
