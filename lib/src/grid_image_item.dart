/// Image source types supported by the widget
enum ImageSourceType {
  network,
  asset,
  file,
  memory,
}

/// Image data class that holds image information
class GridImageItem {
  /// Path or URL to the image
  final String path;
  
  /// Type of image source
  final ImageSourceType sourceType;
  
  /// Optional metadata for the image
  final Map<String, dynamic>? metadata;
  
  /// Optional custom headers for network images
  final Map<String, String>? headers;

  const GridImageItem({
    required this.path,
    required this.sourceType,
    this.metadata,
    this.headers,
  });

  /// Factory constructor for network images
  factory GridImageItem.network(
    String url, {
    Map<String, dynamic>? metadata,
    Map<String, String>? headers,
  }) {
    return GridImageItem(
      path: url,
      sourceType: ImageSourceType.network,
      metadata: metadata,
      headers: headers,
    );
  }

  /// Factory constructor for asset images
  factory GridImageItem.asset(
    String assetPath, {
    Map<String, dynamic>? metadata,
  }) {
    return GridImageItem(
      path: assetPath,
      sourceType: ImageSourceType.asset,
      metadata: metadata,
    );
  }

  /// Factory constructor for file images
  factory GridImageItem.file(
    String filePath, {
    Map<String, dynamic>? metadata,
  }) {
    return GridImageItem(
      path: filePath,
      sourceType: ImageSourceType.file,
      metadata: metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridImageItem &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          sourceType == other.sourceType;

  @override
  int get hashCode => path.hashCode ^ sourceType.hashCode;

  @override
  String toString() {
    return 'GridImageItem{path: $path, sourceType: $sourceType}';
  }
}