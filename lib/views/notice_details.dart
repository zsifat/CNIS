import 'package:chapainawabganjcity/views/widgets/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapainawabganjcity/models/news.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // SliverAppBar with CachedNetworkImage and tap to view full image
            GestureDetector(
              onTap: () {
                // _showFullImage(context, news.image);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImage(imageUrl: news.image),));
              },
              child: CachedNetworkImage(
                imageUrl: news.image,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
              ),
            ),

            // News Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: news.authImg == null
                            ? const AssetImage('assets/images/logo-CNIS.png')
                            : NetworkImage(news.authImg!) as ImageProvider,
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.author,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(news.createdAt),
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),

                  const SizedBox(height: 12),

                  // Full Description
                  Text(
                    news.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show full-screen image in a dialog
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.zero,
            minScale: 0.5,
            maxScale: 7.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.grey)),
            ),
          ),
        );
      },
    );
  }
}
