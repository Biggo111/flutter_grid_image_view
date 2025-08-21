import 'package:flutter/material.dart';
import 'package:flutter_grid_image_view/flutter_grid_image_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Grid Image View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Grid Image View Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample image data
  final List<GridImageItem> sampleImages = [
    GridImageItem.network('https://picsum.photos/400/300?random=1'),
    GridImageItem.network('https://picsum.photos/400/300?random=2'),
    GridImageItem.network('https://picsum.photos/400/300?random=3'),
    GridImageItem.network('https://picsum.photos/400/300?random=4'),
    GridImageItem.network('https://picsum.photos/400/300?random=5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildExampleCard(
            'Single Image',
            FlutterGridImageView(
              images: [sampleImages[0]],
              config: const GridImageConfig(
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          _buildExampleCard(
            'Two Images',
            FlutterGridImageView(
              images: sampleImages.take(2).toList(),
              config: const GridImageConfig(
                height: 270,
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          _buildExampleCard(
            'Multiple Images',
            FlutterGridImageView(
              images: sampleImages,
              config: const GridImageConfig(
                height: 270,
                margin: EdgeInsets.symmetric(horizontal: 16),
                borderRadius: 12,
                spacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}