import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DataCard extends StatelessWidget {
  final String title;
  final String department;
  final String details;
  final String thumb;
  final String contact;

  const DataCard({
    super.key,
    required this.title,
    required this.department,
    required this.details,
    required this.thumb,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    return Container(
      height: 200,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03), // Adjusting padding for responsiveness
          child: Row(
            children: [
              CachedNetworkImage(imageUrl: thumb,width: 60,height: 60,),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: width * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      department, // Address
                      style: TextStyle(
                        fontSize: width * 0.038, // Responsive font size
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      details,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,// Address
                      style: TextStyle(
                        fontSize: width * 0.035, // Responsive font size
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                iconSize: 24,
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  _dialPhoneNumber(contact);

                },
                style: IconButton.styleFrom(backgroundColor: Colors.blue.shade800),
                icon: const Icon(Icons.call),
              ),
            ],
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
    }
  }
}
