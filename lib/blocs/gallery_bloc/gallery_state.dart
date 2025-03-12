part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<Artwork> artworks;
  final List<Album> albums;

  const GalleryLoaded(this.artworks, this.albums);

  @override
  List<Object> get props => [artworks, albums];
}

class GalleryError extends GalleryState {}
