import 'package:exsy/models/artwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArtworkGrid extends StatelessWidget {
  final List<Artwork> artworks;

  const ArtworkGrid({super.key, required this.artworks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 4; // Desktop
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 3; // Tablet
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 2; // Large Mobile
          } else {
            crossAxisCount = 1; // Small Mobile
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: 1,
            ),
            itemCount: artworks.length,
            itemBuilder: (context, index) {
              final artwork = artworks[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ImageOverlay(
                      artworks: artworks,
                      initialIndex: index,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(artwork.imageUrl, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(artwork.title, style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(artwork.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ImageOverlay extends StatefulWidget {
  final List<Artwork> artworks;
  final int initialIndex;

  const ImageOverlay({super.key, required this.artworks, required this.initialIndex});

  @override
  _ImageOverlayState createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<ImageOverlay> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _showPreviousImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.artworks.length) % widget.artworks.length;
    });
  }

  void _showNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.artworks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Focus(
        autofocus: true,
        onKey: (node, event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _showPreviousImage();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _showNextImage();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Expanded(
                          child: Image.asset(widget.artworks[currentIndex].imageUrl, fit: BoxFit.contain),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(widget.artworks[currentIndex].title,
                                  style: const TextStyle(fontSize: 24, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(widget.artworks[currentIndex].description,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
                          onPressed: _showPreviousImage,
                          splashRadius: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward, size: 40, color: Colors.white),
                          onPressed: _showNextImage,
                          splashRadius: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
