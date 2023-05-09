import 'package:flutter/material.dart';

import '../../../core/constant/color_constants.dart';

class PhotosDetailsPage extends StatefulWidget {
  final List<String> images;

  const PhotosDetailsPage({Key? key, required this.images}) : super(key: key);

  @override
  State<PhotosDetailsPage> createState() => _PhotosDetailsPageState();
}

class _PhotosDetailsPageState extends State<PhotosDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Picture Details'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Image.network(
            widget.images[index],
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Error loading image'));
            },
          );
        },
      ),
    );
  }
}
