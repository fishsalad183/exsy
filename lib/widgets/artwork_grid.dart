import 'package:exsy/assets/constants.dart';
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
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
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
                      padding: const EdgeInsets.only(top: 12.0),
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: artwork.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ', ${artwork.year ?? Constants.labelNA}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                      child: SelectableText(
                        '${artwork.technique ?? Constants.labelNA}, ${artwork.dimensions ?? Constants.labelNA}',
                        maxLines: 2,
                      ),
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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  void _showPreviousImage() {
    if (currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _showNextImage() {
    if (currentIndex < widget.artworks.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
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
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: widget.artworks.length,
                    itemBuilder: (context, index) {
                      final artwork = widget.artworks[index];
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          Expanded(
                            child: InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 4.0,
                              child: Image.asset(artwork.imageUrl, fit: BoxFit.contain),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: artwork.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ', ${artwork.year ?? Constants.labelNA}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SelectableText(
                                  '${artwork.technique ?? Constants.labelNA}, ${artwork.dimensions ?? Constants.labelNA}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
                if (MediaQuery.of(context).size.width > 600 && currentIndex > 0)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _showPreviousImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (MediaQuery.of(context).size.width > 600 && currentIndex < widget.artworks.length - 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _showNextImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.arrow_forward, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (MediaQuery.of(context).size.width <= 600 && currentIndex > 0)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _showPreviousImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (MediaQuery.of(context).size.width <= 600 && currentIndex < widget.artworks.length - 1)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _showNextImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.arrow_forward, size: 40, color: Colors.white),
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
