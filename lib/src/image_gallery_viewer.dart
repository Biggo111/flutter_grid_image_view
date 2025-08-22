import 'package:flutter/material.dart';
import 'grid_image_item.dart';

/// Full screen image gallery viewer with zoom and pan capabilities
class ImageGalleryViewer extends StatefulWidget {
  /// List of images to display
  final List<GridImageItem> images;

  /// Initial index to start from
  final int initialIndex;

  /// Background color of the gallery
  final Color? backgroundColor;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Custom app bar widget
  final PreferredSizeWidget? customAppBar;

  /// Custom page indicator widget
  final Widget Function(int currentIndex, int totalImages)? pageIndicator;

  const ImageGalleryViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.backgroundColor,
    this.showAppBar = true,
    this.customAppBar,
    this.pageIndicator,
  });

  @override
  State<ImageGalleryViewer> createState() => _ImageGalleryViewerState();
}

class _ImageGalleryViewerState extends State<ImageGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black,
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  panEnabled: false,
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: _buildFullScreenImage(widget.images[index]),
                ),
              );
            },
          ),
          if (widget.pageIndicator != null && widget.images.length > 1)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: widget.pageIndicator!(_currentIndex, widget.images.length),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (widget.customAppBar != null) {
      return widget.customAppBar;
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: widget.images.length > 1
          ? Text(
              '${_currentIndex + 1} of ${widget.images.length}',
              style: const TextStyle(color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFullScreenImage(GridImageItem imageItem) {
    switch (imageItem.sourceType) {
      case ImageSourceType.network:
        return Image.network(
          imageItem.path,
          headers: imageItem.headers,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.white, size: 50),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        );
      case ImageSourceType.asset:
        return Image.asset(
          imageItem.path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.white, size: 50),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load asset',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        );
      case ImageSourceType.file:
      case ImageSourceType.memory:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.white, size: 50),
              SizedBox(height: 8),
              Text(
                'File and Memory sources not implemented in this version',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }
}
