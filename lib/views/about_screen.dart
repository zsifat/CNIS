import 'package:chapainawabganjcity/viewmodels/about_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/states/aboutState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutState = ref.watch(aboutViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CNIS'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        children: [
          // Company Info Section
          _buildCompanySection(aboutState),

          const SizedBox(height: 10),

          // Contact Information (List Style)
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader("Contact Information"),
                InkWell(
                    onTap: () {
                      _dialPhoneNumber(aboutState.about!.phone);
                    },
                    child: _buildInfoTile(Icons.phone, "Phone", aboutState.about!.phone)),
                InkWell(
                    onTap: () {
                      _launchEmail(aboutState.about!.email);
                    },
                    child: _buildInfoTile(Icons.email, "Email", aboutState.about!.email)),
                _buildInfoTile(Icons.location_on, "Address", aboutState.about!.address),

                const Divider(),

                _buildSectionHeader("Follow Us"),
                _buildSocialMediaTile(FontAwesomeIcons.facebook, "Facebook", aboutState.about!.facebook),
                _buildSocialMediaTile(FontAwesomeIcons.squareInstagram, "Instagram", aboutState.about!.instagram),
                _buildSocialMediaTile(FontAwesomeIcons.linkedin, "LinkedIn", aboutState.about!.instagram),
                _buildSocialMediaTile(FontAwesomeIcons.xTwitter, "Twitter", aboutState.about!.twitter),
                const Divider(),

                // Developed by EBEXSOFT
                _buildDevelopedBySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📌 **Company Info Section with Logo & Owner's Image**
  Widget _buildCompanySection(AboutState aboutState) {
    return Column(
      children: [
        const SizedBox(height: 10),

        // Owner Image
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: const AssetImage('assets/images/pp.png'),
          onBackgroundImageError: (_, __) =>
          const Icon(Icons.person, size: 50, color: Colors.grey),
        ),
      ],
    );
  }

  // 📌 **Section Headers for Better UI**
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // 📌 **Reusable ListTile for Contact & Address**
  Widget _buildInfoTile(IconData icon, String title, String info) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      subtitle: Text(
        info,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }

  // 📌 **Social Media Tile with Icons & Clickable Links**
  Widget _buildSocialMediaTile(IconData icon, String title, String url) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.open_in_new),
      onTap: () {
        _launchUrl(url);
      },
    );
  }
}

// Launch URL function
Future<void> _launchUrl(String url) async {
  final Uri url0 = Uri.parse(url);
  if (!await launchUrl(url0)) {
    throw Exception('Could not launch $url0');
  }
}

void _launchEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {'subject': 'Support Request'},
  );

  if (await launchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch email client';
  }
}

// Launch phone call
void _dialPhoneNumber(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
  }
}

Widget _buildDevelopedBySection() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Developed by ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          GestureDetector(
            onTap: () {
              _launchUrl('http://www.ebexsoft.com/');
              },
            child: const Text(
              "EBEXSOFT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
    ),
  );
}

