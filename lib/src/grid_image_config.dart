import 'package:flutter/material.dart';

/// Configuration class for customizing the grid image view
class GridImageConfig {
  /// Height of the image grid container
  final double height;
  
  /// Margin around the container
  final EdgeInsetsGeometry? margin;
  
  /// Padding inside the container
  final EdgeInsetsGeometry? padding;
  
  /// Border radius for individual images
  final double borderRadius;
  
  /// Spacing between images
  final double spacing;
  
  /// Background color for the remaining count overlay
  final Color overlayColor;
  
  /// Text style for the remaining count
  final TextStyle? countTextStyle;
  
  /// Custom placeholder widget when image fails to load
  final Widget? placeholder;
  
  /// Custom error widget when image fails to load
  final Widget? errorWidget;
  
  /// Enable/disable image tap functionality
  final bool enableImageTap;

  const GridImageConfig({
    this.height = 270.0,
    this.margin,
    this.padding,
    this.borderRadius = 12.0,
    this.spacing = 4.0,
    this.overlayColor = const Color(0x88000000),
    this.countTextStyle,
    this.placeholder,
    this.errorWidget,
    this.enableImageTap = true,
  });

  /// Create a copy of this config with updated values
  GridImageConfig copyWith({
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    double? spacing,
    Color? overlayColor,
    TextStyle? countTextStyle,
    Widget? placeholder,
    Widget? errorWidget,
    bool? enableImageTap,
  }) {
    return GridImageConfig(
      height: height ?? this.height,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      spacing: spacing ?? this.spacing,
      overlayColor: overlayColor ?? this.overlayColor,
      countTextStyle: countTextStyle ?? this.countTextStyle,
      placeholder: placeholder ?? this.placeholder,
      errorWidget: errorWidget ?? this.errorWidget,
      enableImageTap: enableImageTap ?? this.enableImageTap,
    );
  }
}