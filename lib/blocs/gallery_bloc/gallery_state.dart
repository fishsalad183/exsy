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

  const GalleryLoaded(this.artworks);

  @override
  List<Object> get props => [artworks];
}

class GalleryError extends GalleryState {}
