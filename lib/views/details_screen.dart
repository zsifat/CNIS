import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/views/widgets/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final Data data;
  const DetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          _dialPhoneNumber(data.contact);
        },
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.call,
            color: Colors.white,
            size: 24,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
          child: SingleChildScrollView( // Make the content scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rounded Image at the top
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImage(imageUrl: data.thumb),));
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: data.thumb,
                      placeholder: (context, url) {
                        return const Icon(Icons.image);
                      },
                      width: double.infinity, // Full width
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                InkWell(
                  onTap: () {
                    _openLink(data.googleMap ?? data.link ?? '');
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(CupertinoIcons.link,color: Colors.green.shade800,),
                    ],
                  ),
                ),

                const SizedBox(height: 16,),
                // Padding for the headline and details below the image
                const Text(
                  'বিস্তারিত',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4,),
                Text(
                  data.details,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dialPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint("Could not launch phone call.");
    }
  }

  void _openLink(String? link) async {
    if (link == null || link.isEmpty) {
      debugPrint("No URL provided.");
      return;
    }
    final Uri launchUri = Uri.parse(link);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint("Could not open link.");
    }
  }
}
