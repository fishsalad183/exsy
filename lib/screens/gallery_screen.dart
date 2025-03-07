import 'package:collection/collection.dart';
import 'package:exsy/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:exsy/models/artwork.dart';
import 'package:exsy/repositories/album_repository.dart';
import 'package:exsy/repositories/artwork_repository.dart';
import 'package:exsy/widgets/artwork_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exsy/models/album.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? selectedAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        actions: [
          _buildNavButton(context, 'Home', '/'),
          _buildNavButton(context, 'Gallery', '/gallery'),
          _buildNavButton(context, 'Contact', '/contact'),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            // Mobile layout: horizontally scrollable list at the top
            return Column(
              children: [
                _buildAlbumList(context),
                Expanded(
                  child: BlocProvider(
                    create: (context) => GalleryBloc(ArtworkRepository(), AlbumRepository())..add(LoadGallery()),
                    child: BlocBuilder<GalleryBloc, GalleryState>(
                      builder: (context, state) {
                        if (state is GalleryLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is GalleryLoaded) {
                          final artworks = selectedAlbum == null
                              ? state.artworks
                              : state.artworks
                                  .where((artwork) => _isArtworkInSelectedAlbum(artwork, state.albums))
                                  .toList();
                          return Container(
                            color: const Color(0xFFE0E0E0),
                            child: ArtworkGrid(artworks: artworks),
                          );
                        } else if (state is GalleryError) {
                          return const Center(child: Text('Failed to load gallery'));
                        } else {
                          return const Center(child: Text('Unknown state'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Desktop layout: vertical list on the left
            return Row(
              children: [
                _buildAlbumList(context),
                Expanded(
                  child: BlocProvider(
                    create: (context) => GalleryBloc(ArtworkRepository(), AlbumRepository())..add(LoadGallery()),
                    child: BlocBuilder<GalleryBloc, GalleryState>(
                      builder: (context, state) {
                        if (state is GalleryLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is GalleryLoaded) {
                          final artworks = selectedAlbum == null
                              ? state.artworks
                              : state.artworks
                                  .where((artwork) => _isArtworkInSelectedAlbum(artwork, state.albums))
                                  .toList();
                          return Container(
                            color: const Color(0xFFE0E0E0),
                            child: ArtworkGrid(artworks: artworks),
                          );
                        } else if (state is GalleryError) {
                          return const Center(child: Text('Failed to load gallery'));
                        } else {
                          return const Center(child: Text('Unknown state'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  bool _isArtworkInSelectedAlbum(Artwork artwork, List<Album> albums) {
    final album = albums.firstWhereOrNull((album) => album.title == selectedAlbum);
    return album != null && artwork.isInAlbum(album);
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        onPressed: isSelected
            ? null
            : () {
                Navigator.pushReplacementNamed(context, route);
              },
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE0E0E0) : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumList(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          // Mobile layout: horizontally scrollable list at the top
          return Container(
            height: 60, // Reduced height
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            child: FutureBuilder<List<Album>>(
              future: AlbumRepository().fetchAlbums(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load albums'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No albums available'));
                } else {
                  final albums = snapshot.data!;
                  return Scrollbar(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Text(
                              'Albums',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IntrinsicWidth(
                            child: ListTile(
                              title: const Text('All artworks'),
                              onTap: selectedAlbum == null
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedAlbum = null;
                                      });
                                      Navigator.pushReplacementNamed(context, '/gallery');
                                    },
                              selected: selectedAlbum == null,
                              selectedTileColor: Colors.grey.shade300,
                            ),
                          ),
                          ...albums.map((album) {
                            final bool isSelected = selectedAlbum == album.title;
                            return IntrinsicWidth(
                              child: ListTile(
                                title: Text(
                                  album.title,
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                onTap: isSelected
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedAlbum = album.title;
                                        });
                                        Navigator.pushReplacementNamed(context, '/gallery?album=${album.title}');
                                      },
                                selected: isSelected,
                                selectedTileColor: Colors.grey.shade300,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        } else {
          // Desktop layout: vertical list on the left
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              border: Border(
                right: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            child: FutureBuilder<List<Album>>(
              future: AlbumRepository().fetchAlbums(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load albums'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No albums available'));
                } else {
                  final albums = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                        child: Text(
                          'Albums',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('All artworks'),
                        onTap: selectedAlbum == null
                            ? null
                            : () {
                                setState(() {
                                  selectedAlbum = null;
                                });
                                Navigator.pushReplacementNamed(context, '/gallery');
                              },
                        selected: selectedAlbum == null,
                        selectedTileColor: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: ListView(
                          children: albums.map((album) {
                            final bool isSelected = selectedAlbum == album.title;
                            return ListTile(
                              title: Text(
                                album.title,
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                              onTap: isSelected
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedAlbum = album.title;
                                      });
                                      Navigator.pushReplacementNamed(context, '/gallery?album=${album.title}');
                                    },
                              selected: isSelected,
                              selectedTileColor: Colors.grey.shade300,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
