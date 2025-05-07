import 'package:exsy/assets/constants.dart';
import 'package:exsy/models/artwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArtworkGridItem extends StatefulWidget {
  final Artwork artwork;
  final VoidCallback onTap;
  final bool isMobile;

  const ArtworkGridItem({
    super.key,
    required this.artwork,
    required this.onTap,
    required this.isMobile,
  });

  @override
  State<ArtworkGridItem> createState() => _ArtworkGridItemState();
}

class _ArtworkGridItemState extends State<ArtworkGridItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: widget.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Expanded(
              child: Image.asset(
                widget.artwork.imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.artwork.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: widget.isMobile ? TextAlign.center : TextAlign.start,
            ),
            if (widget.artwork.year != null)
              Text(
                widget.artwork.year.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: widget.isMobile ? TextAlign.center : TextAlign.start,
              ),
            if (widget.artwork.technique != null || widget.artwork.dimensions != null)
              Text(
                [
                  if (widget.artwork.technique != null) widget.artwork.technique,
                  if (widget.artwork.dimensions != null) widget.artwork.dimensions,
                ].where((e) => e != null).join(' • '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: widget.isMobile ? TextAlign.center : TextAlign.start,
              ),
          ],
        ),
      ),
    );
  }
}

class ArtworkGrid extends StatelessWidget {
  final List<Artwork> artworks;

  const ArtworkGrid({super.key, required this.artworks});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        bool isMobile = constraints.maxWidth <= 600;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          primary: false,
          cacheExtent: 1000,
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemCount: artworks.length,
          itemBuilder: (context, index) {
            final artwork = artworks[index];
            return ArtworkGridItem(
              artwork: artwork,
              onTap: () => _showImageOverlay(context, index),
              isMobile: isMobile,
            );
          },
        );
      },
    );
  }

  void _showImageOverlay(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => ImageOverlay(
        artworks: artworks,
        initialIndex: index,
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
  late TransformationController _transformationController;
  bool _isZoomed = false;
  double _lastScale = 1.0;
  Offset? _lastFocalPoint;
  bool _isAtLeftEdge = false;
  bool _isAtRightEdge = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChange);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChange);
    _transformationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTransformationChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    setState(() {
      _isZoomed = scale > 1.1;
      _lastScale = scale;
    });
  }

  void _handleImageChange(int index) {
    setState(() {
      currentIndex = index;
      _transformationController.value = Matrix4.identity();
      _isZoomed = false;
      _isAtLeftEdge = false;
      _isAtRightEdge = false;
    });
  }

  void _showPreviousImage() {
    if (currentIndex > 0) {
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _transformationController.value = Matrix4.identity();
        _isZoomed = false;
      });
    }
  }

  void _showNextImage() {
    if (currentIndex < widget.artworks.length - 1) {
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _transformationController.value = Matrix4.identity();
        _isZoomed = false;
      });
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
                    physics: _isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: _handleImageChange,
                    itemCount: widget.artworks.length,
                    itemBuilder: (context, index) {
                      final artwork = widget.artworks[index];
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${currentIndex + 1} / ${widget.artworks.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: InteractiveViewer(
                              transformationController: _transformationController,
                              minScale: 1.0,
                              maxScale: 4.0,
                              onInteractionStart: (details) {
                                _lastFocalPoint = details.focalPoint;
                                _isAtLeftEdge = false;
                                _isAtRightEdge = false;
                              },
                              onInteractionUpdate: (details) {
                                if (!_isZoomed) return;

                                final Matrix4 transform = _transformationController.value;
                                final double x = transform.getTranslation().x;
                                final scale = transform.getMaxScaleOnAxis();

                                final renderObject = context.findRenderObject();
                                if (renderObject is RenderBox) {
                                  final size = renderObject.size;
                                  final double maxOffset = (scale - 1) * size.width / 2;

                                  // Add a threshold to prevent accidental swipes during pinch-zoom
                                  const double horizontalSwipeThreshold = 40.0;

                                  setState(() {
                                    _isAtLeftEdge = x >= maxOffset - horizontalSwipeThreshold;
                                    _isAtRightEdge = x <= -maxOffset + horizontalSwipeThreshold;
                                  });
                                }

                                _lastFocalPoint = details.focalPoint;
                              },
                              onInteractionEnd: (details) {
                                if (!_isZoomed) {
                                  _transformationController.value = Matrix4.identity();
                                  return;
                                }

                                // Only allow swiping if the user is at the edge and the gesture is not primarily a zoom
                                if (_isAtLeftEdge && currentIndex > 0) {
                                  _showPreviousImage();
                                  _transformationController.value = Matrix4.identity();
                                } else if (_isAtRightEdge && currentIndex < widget.artworks.length - 1) {
                                  _showNextImage();
                                  _transformationController.value = Matrix4.identity();
                                }
                              },
                              child: Image.asset(
                                artwork.imageUrl,
                                fit: BoxFit.contain,
                              ),
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
