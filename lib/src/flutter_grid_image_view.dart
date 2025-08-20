import 'package:flutter/material.dart';
import 'grid_image_config.dart';
import 'grid_image_item.dart';
import 'image_gallery_viewer.dart';

/// Callback function type for when images are tapped
typedef OnImageTap = void Function(int index, List<GridImageItem> images);

/// Main widget for displaying images in a grid layout with remaining count
class FlutterGridImageView extends StatelessWidget {
  /// List of images to display
  final List<GridImageItem> images;
  
  /// Configuration for customizing the appearance
  final GridImageConfig config;
  
  /// Callback when an image or the grid is tapped
  final OnImageTap? onImageTap;
  
  /// Whether to show a default full-screen gallery when tapped
  final bool showDefaultGallery;

  const FlutterGridImageView({
    super.key,
    required this.images,
    this.config = const GridImageConfig(),
    this.onImageTap,
    this.showDefaultGallery = true,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: config.height,
      margin: config.margin,
      padding: config.padding,
      child: _buildImageGrid(context),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    if (images.length == 1) {
      return _buildSingleImage(context);
    } else if (images.length == 2) {
      return _buildTwoImages(context);
    } else {
      return _buildMultipleImages(context);
    }
  }

  Widget _buildSingleImage(BuildContext context) {
    return _buildClickableImage(
      context: context,
      imageItem: images[0],
      index: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.borderRadius),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _buildImage(images[0], BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTwoImages(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(config.spacing),
            child: _buildClickableImage(
              context: context,
              imageItem: images[0],
              index: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(config.borderRadius),
                child: SizedBox(
                  height: double.infinity,
                  child: _buildImage(images[0], BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: config.spacing),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(config.spacing),
            child: _buildClickableImage(
              context: context,
              imageItem: images[1],
              index: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(config.borderRadius),
                child: SizedBox(
                  height: double.infinity,
                  child: _buildImage(images[1], BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleImages(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(config.spacing),
            child: _buildClickableImage(
              context: context,
              imageItem: images[0],
              index: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(config.borderRadius),
                child: SizedBox(
                  height: double.infinity,
                  child: _buildImage(images[0], BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: config.spacing),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(config.spacing),
                  child: _buildClickableImage(
                    context: context,
                    imageItem: images[1],
                    index: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(config.borderRadius),
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildImage(images[1], BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: config.spacing),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(config.spacing),
                  child: _buildRemainingImages(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemainingImages(BuildContext context) {
    return _buildClickableImage(
      context: context,
      imageItem: images[2],
      index: 2,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(config.borderRadius),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _buildImage(images[2], BoxFit.cover),
            ),
          ),
          if (images.length > 3)
            ClipRRect(
              borderRadius: BorderRadius.circular(config.borderRadius),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: config.overlayColor,
                child: Center(
                  child: Text(
                    '+${images.length - 3}',
                    style: config.countTextStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClickableImage({
    required BuildContext context,
    required GridImageItem imageItem,
    required int index,
    required Widget child,
  }) {
    if (!config.enableImageTap) {
      return child;
    }

    return GestureDetector(
      onTap: () {
        if (onImageTap != null) {
          onImageTap!(index, images);
        } else if (showDefaultGallery) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImageGalleryViewer(
                images: images,
                initialIndex: index,
              ),
            ),
          );
        }
      },
      child: child,
    );
  }

  Widget _buildImage(GridImageItem imageItem, BoxFit fit) {
    switch (imageItem.sourceType) {
      case ImageSourceType.network:
        return Image.network(
          imageItem.path,
          headers: imageItem.headers,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return config.placeholder ??
                Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          },
          errorBuilder: (context, error, stackTrace) {
            return config.errorWidget ??
                Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                );
          },
        );
      case ImageSourceType.asset:
        return Image.asset(
          imageItem.path,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return config.errorWidget ??
                Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                );
          },
        );
      case ImageSourceType.file:
      case ImageSourceType.memory:
        return config.errorWidget ??
            Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'File/Memory sources\nnot implemented',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
    }
  }
}