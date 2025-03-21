import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapainawabganjcity/views/widgets/youtube_player_screen.dart';
import 'package:flutter/material.dart';

import '../../models/data.dart';

class DataCardSecondVersion extends StatelessWidget {
  final Data data;
  const DataCardSecondVersion({super.key, required this.data});

  String extractVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      final queryParams = uri.queryParameters;
      return queryParams['v'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;

    return InkWell(
      onTap: () {
        final videoId = extractVideoId(data.googleMap ?? '');
        if(videoId.isNotEmpty){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenPlayerScreen(videoId: videoId),
              ));
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: data.thumb,
                  width: double.infinity,
                  height: size.height * 0.3,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Icon(Icons.image_outlined),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 8),
                child: Text(
                  data.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.width * 0.040,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
