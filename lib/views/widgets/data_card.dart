import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/data.dart';

class DataCard extends StatelessWidget {
  final Data data;

  const DataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;

    return InkWell(
      onTap: () {
        _showDetailsDialog(context, data);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showImagePopup(context, data.thumb),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data.thumb,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   "Department: ${data.department}",
                    //   style: TextStyle(
                    //     fontSize: width * 0.035,
                    //     color: Colors.green.shade800,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const SizedBox(height: 6),
                    Text(
                      data.degree ?? data.details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.034,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ContactButtons(contactNumber: data.contact,googleMap: data.googleMap ?? '',)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showDetailsDialog(BuildContext context, Data data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          backgroundColor: Colors.white, // Light greenish background
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with Icon
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Data Fields
                  _infoRow('Education', data.degree),
                  _infoRow('Details', data.details),
                  _infoRow("Address", data.address),
                  _infoRow("Chamber", data.chamber),
                  _infoRow("Email", data.email),
                  _infoRow("Price", data.price),
                  _infoRow("Blood Group", data.bloodGroup),
                  _infoRow("Contact", data.contact),

                  const SizedBox(height: 16),

                  // Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Widget to display info row only if the value is not null
  Widget _infoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Label is bold
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal, // Value remains normal
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Close the popup when tapped
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 3.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class ContactButtons extends StatelessWidget {
  final String contactNumber;
  final String googleMap;

  ContactButtons({required this.contactNumber,required this.googleMap});

  void _dialPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint("Could not launch phone call.");
    }
  }

  void _openGoogleMap(String? googleMapUrl) async {
    if (googleMapUrl == null || googleMapUrl.isEmpty) {
      debugPrint("No Google Map URL provided.");
      return;
    }
    final Uri launchUri = Uri.parse(googleMapUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint("Could not open Google Maps.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Call Button (Dark Green)
        Expanded(
          child: ElevatedButton(
            onPressed: () => _dialPhoneNumber(contactNumber),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.call, color: Colors.white,size: 14,),
                SizedBox(width: 4),
                Text(
                  "কল করুন",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12),
                ),
              ],
            ),
          ),
        ),


        // Google Map Button (Light Green)
        Expanded(
          child: ElevatedButton(
            onPressed: () => _openGoogleMap(googleMap),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.place, color: Colors.green,size: 14,),
                SizedBox(width: 6),
                Text(
                  "ম্যাপ",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
