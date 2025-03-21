import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl; // URL or path to the image

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl), // Use AssetImage if local
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black
          ), // Set the background of the image viewer to black
        ),
      ),
    );
  }
}
