import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodels/about_viewmodel.dart';
import '../../feature/profile/presentation/views/about_screen.dart';
import '../advertisement_screen.dart';
import '../main_screen.dart';
import '../notice_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutState = ref.watch(aboutViewModelProvider);

    return Drawer(
      backgroundColor: Colors.white,
      width: 260,
      child: Column(
        children: [
          // Drawer Header
          SizedBox(
            height: 230,
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-CNIS.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'CNIS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Content to Prevent Overflow
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // _buildDrawerItem(Icons.home, "হোম", () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const MainScreen(),
                  //   ));
                  // }),
                  // _buildDrawerItem(Icons.person, "নোটিশ", () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const NoticeScreen(),
                  //   ));
                  // }),
                  // _buildDrawerItem(Icons.business, 'বিজ্ঞাপন', () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const AdvertisementScreen(),
                  //   ));
                  // }),
                  // _buildDrawerItem(Icons.info, 'প্রোফাইল', () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const AboutScreen()));
                  // }),

                  // Divider(color: Colors.grey.shade300),

                  _buildSectionHeader("সাপোর্ট"),
                  _buildDrawerItem(FontAwesomeIcons.envelopeCircleCheck, 'ইমেইল করুন', () {
                    _launchEmail(aboutState.about!.email);
                  }),
                  _buildDrawerItem(FontAwesomeIcons.phone, "কল করুন", () {
                    _dialPhoneNumber(aboutState.about!.phone);
                  }),
                  _buildDrawerItem(FontAwesomeIcons.sms, "মেসেজ করুন", () {
                    _launchSMS(aboutState.about!.phone);
                  }),

                  Divider(color: Colors.grey.shade300),

                  // App Share Section
                  _buildSectionHeader("অ্যাপ শেয়ার করুন"),
                  Center(
                    child: Column(
                      children: [
                        QrImageView(
                          data: 'https://play.google.com/store/apps/details?id=com.example.myapp',
                          version: QrVersions.auto,
                          size: 120,
                          foregroundColor: Colors.black, // QR color
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _launchUrl('https://play.google.com/store/apps/details?id=com.ebexsoft.cnis'),
                          icon: const FaIcon(FontAwesomeIcons.googlePlay, color: Colors.white, size: 18), // Play Store Icon
                          label: const Text(
                            'Get it on Google Play',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800, // Darker green for a premium look
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16), // More rounded for a modern feel
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            elevation: 5, // Slightly increased elevation for a floating effect
                            shadowColor: Colors.green.shade900.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),


                  Divider(color: Colors.grey.shade300),
                  _buildSectionHeader('যুক্ত হোন'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialMediaButton(FontAwesomeIcons.facebookF, aboutState.about!.facebook),
                        _socialMediaButton(FontAwesomeIcons.squareInstagram, aboutState.about!.instagram),
                        _socialMediaButton(FontAwesomeIcons.linkedin, aboutState.about!.linkdin),
                        _socialMediaButton(FontAwesomeIcons.xTwitter, aboutState.about!.twitter),
                      ],
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

  // Build individual drawer item
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 24,),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.green,
        ),
      ),
    );
  }

  // Social media button (generic)
  Widget _socialMediaButton(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, size: 28),
      onPressed: () {
        _launchUrl(url);
      },
    );
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

    if (!await launchUrl(emailUri)) {
      throw 'Could not launch email client';
    }
  }

  // Launch phone call
  void _dialPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch phone dialer';
    }
  }

  // Launch SMS
  void _launchSMS(String phoneNo) async {
    final smsUrl = 'sms:$phoneNo';
    if (!await launchUrl(Uri.parse(smsUrl))) {
      throw 'Could not launch SMS';
    }
  }
}
