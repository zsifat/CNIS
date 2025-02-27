import 'package:chapainawabganjcity/views/about_screen.dart';
import 'package:chapainawabganjcity/views/advertisement_screen.dart';
import 'package:chapainawabganjcity/views/home_screen.dart';
import 'package:chapainawabganjcity/views/main_screen.dart';
import 'package:chapainawabganjcity/views/notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodels/about_viewmodel.dart';

class NewAppDrawer extends ConsumerWidget {
  const NewAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutState = ref.watch(aboutViewModelProvider);
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
      width: 260,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with Image and Title
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(
            //         'assets/images/logo-CNIS.png', // Replace with your logo
            //         width: 100,
            //         height: 100,
            //         fit: BoxFit.cover,
            //       ),
            //     ],
            //   ),
            // ),
        
            // Scrollable Content to Prevent Overflow
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDrawerItem(Icons.home, "হোম", () {
                      // Navigate to Home screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ));
                    }),
                    _buildDrawerItem(Icons.campaign, "নোটিশ", () {
                      // Navigate to Notification screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoticeScreen(),
                      ));
                    }),
                    _buildDrawerItem(Icons.newspaper, 'বিজ্ঞাপন', () {
                      // Navigate to Notification screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdvertisementScreen(),
                      ));
                    }),
                    _buildDrawerItem(Icons.account_circle, "প্রোফাইল", () {
                      // Navigate to Profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(),
                        ),
                      );
                    }),
        
                    Divider(color: Colors.grey.shade300),
        
                    // Social Media Section
                    _buildSectionHeader("যোগাযোগ করুন"),
                    _buildSocialMediaButton(FontAwesomeIcons.facebookF, aboutState.about!.facebook,'ফেসবুক গ্রুপ'),
                    _buildSocialMediaButton(FontAwesomeIcons.instagram, aboutState.about!.instagram,'ইনস্ট্রাগ্রাম'),
                    _buildSocialMediaButton(FontAwesomeIcons.youtube, aboutState.about!.linkdin,"ইউটিউব"),
        
                    Divider(color: Colors.grey.shade300),
        
                    // Support Section
                    _buildSectionHeader("সাপোর্ট"),
                    _buildDrawerItem(Icons.email_outlined, 'ইমেইল করুন', () {
                      _launchEmail(aboutState.about!.email);
                    }),
                    _buildDrawerItem(Icons.call, "কল করুন", () {
                      _dialPhoneNumber(aboutState.about!.phone);
                    }),
                    _buildDrawerItem(Icons.message, "মেসেজ করুন", () {
                      _launchSMS(aboutState.about!.phone);
                    }),
        
                    Divider(color: Colors.grey.shade300),
        
                    // Other Actions
                    _buildSectionHeader("অন্যান্য"),
                    _buildDrawerItem(Icons.share, "শেয়ার করুন", () {
                      shareApp();
                    }),
                    SizedBox(height: 8,)
                  ],
                ),
              ),
            ),
          ],
        ),
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
            Icon(icon, size: 24),
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
  Widget _buildSocialMediaButton(IconData icon, String url, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: InkWell(
        onTap: () {
          _launchUrl(url);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 22),
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

  // Launch URL function
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launch(uri.toString())) {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Support Request'},
    );

    if (!await launch(emailUri.toString())) {
      throw 'Could not launch email client';
    }
  }

  // Launch phone call
  void _dialPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launch(launchUri.toString())) {
      throw 'Could not launch phone dialer';
    }
  }

  // Launch SMS
  void _launchSMS(String phoneNo) async {
    final smsUrl = 'sms:$phoneNo';
    if (!await launch(smsUrl)) {
      throw 'Could not launch SMS';
    }
  }

  void shareApp() async{
    await Share.share('https://play.google.com/store/apps/details?id=com.ebexsoft.cnis');
  }
}
