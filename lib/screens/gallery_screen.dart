import 'package:collection/collection.dart';
import 'package:exsy/assets/constants.dart';
import 'package:exsy/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:exsy/models/artwork.dart';
import 'package:exsy/repositories/album_repository.dart';
import 'package:exsy/repositories/artwork_repository.dart';
import 'package:exsy/widgets/artwork_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exsy/models/album.dart';

class GalleryScreen extends StatefulWidget {
  final String? selectedAlbum;

  const GalleryScreen({super.key, this.selectedAlbum});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? selectedAlbum;
  late Future<List<Album>> _albumsFuture;
  final AlbumRepository _albumRepository = AlbumRepository();

  @override
  void initState() {
    super.initState();
    selectedAlbum = widget.selectedAlbum;
    _albumsFuture = _albumRepository.fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallerScreen = MediaQuery.of(context).size.width <= 1200;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        leadingWidth: isSmallerScreen ? 0 : 240,
        leading: isSmallerScreen
            ? null
            : GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Constants.labelNameSurname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildAlbumList(context),
                  const SizedBox(height: 8.0),
                  BlocProvider(
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
                  const SizedBox(height: 32.0),
                ],
              ),
            );
          } else {
            // Desktop layout: vertical list on the left
            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
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
                              alignment: Alignment.topLeft,
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
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    final isSelected = ModalRoute.of(context)?.settings.name?.contains('/gallery') == true && route == '/gallery';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: 100,
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
      ),
    );
  }

  Widget _buildAlbumList(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          // Mobile layout: dropdown button for selecting albums
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: FutureBuilder<List<Album>>(
                  future: _albumsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Failed to load albums'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No albums available'));
                    } else {
                      final albums = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 24.0),
                              child: Text(
                                '${Constants.labelSelectAlbum}:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: DropdownButton<String>(
                                value: selectedAlbum,
                                hint: const Text(
                                  Constants.labelAlbum,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                dropdownColor: Colors.black,
                                isDense: true,
                                isExpanded: false,
                                underline: Container(),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      Constants.labelAllArtworks,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ...albums.map((album) {
                                    return DropdownMenuItem<String>(
                                      value: album.title,
                                      child: Text(
                                        album.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAlbum = value;
                                  });
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/gallery${value != null ? '?album=$value' : ''}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          // Desktop layout: vertical list on the left
          return Container(
            width: 150,
            padding: const EdgeInsets.only(left: 8.0),
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
              future: _albumsFuture,
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
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: Text(
                          'Albums',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(),
                      ),
                      const SizedBox(height: 8.0),
                      ListTile(
                        title: const Text(Constants.labelAllArtworks),
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

  bool _isArtworkInSelectedAlbum(Artwork artwork, List<Album> albums) {
    final album = albums.firstWhereOrNull((album) => album.title == selectedAlbum);
    return album != null && artwork.isInAlbum(album);
  }
}
