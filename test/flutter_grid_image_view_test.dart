import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_grid_image_view/flutter_grid_image_view.dart';

void main() {
  group('FlutterGridImageView Tests', () {
    testWidgets('renders empty widget when no images provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FlutterGridImageView(images: [])),
      );

      expect(find.byType(FlutterGridImageView), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders single image correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterGridImageView(
            images: [GridImageItem.network('https://example.com/image.jpg')],
          ),
        ),
      );

      expect(find.byType(FlutterGridImageView), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    test('GridImageItem network factory creates correct instance', () {
      const url = 'https://example.com/image.jpg';
      final item = GridImageItem.network(url);

      expect(item.path, equals(url));
      expect(item.sourceType, equals(ImageSourceType.network));
    });

    test('GridImageConfig copyWith works correctly', () {
      const config = GridImageConfig(height: 200, borderRadius: 8);

      final newConfig = config.copyWith(height: 300);

      expect(newConfig.height, equals(300));
      expect(newConfig.borderRadius, equals(8));
    });
  });
}
