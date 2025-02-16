import 'package:exsy/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:exsy/repositories/artwork_repository.dart';
import 'package:exsy/widgets/artwork_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

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
      body: BlocProvider(
        create: (context) => GalleryBloc(ArtworkRepository())..add(LoadGallery()),
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            if (state is GalleryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GalleryLoaded) {
              return Container(
                color: const Color(0xFFE0E0E0),
                child: ArtworkGrid(artworks: state.artworks),
              );
            } else if (state is GalleryError) {
              return const Center(child: Text('Failed to load gallery'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
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
}
