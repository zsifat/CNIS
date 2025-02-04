import 'package:chapainawabganjcity/viewmodels/about_viewmodel.dart';
import 'package:chapainawabganjcity/views/about_screen.dart';
import 'package:chapainawabganjcity/views/advertisement_screen.dart';
import 'package:chapainawabganjcity/views/main_screen.dart';
import 'package:chapainawabganjcity/views/notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutState = ref.watch(aboutViewModelProvider);

    return Drawer(
      backgroundColor: Colors.white,
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header
          SizedBox(
            height: 230,
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade900, // Professional dark blue background
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-CNIS.png', // Your logo image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'CNIS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Items (Navigation)
          _buildDrawerItem(Icons.home, "হোম", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
          }),
          _buildDrawerItem(Icons.person, "নোটিশ", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NoticeScreen(),
            ));
          }),
          _buildDrawerItem(Icons.person, 'বিজ্ঞাপন', () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AdvertisementScreen(),
            ));
          }),
          _buildDrawerItem(Icons.info, 'প্রোফাইল', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen(),));
          }),

          // Divider for better separation
          Divider(color: Colors.grey.shade300),

          // Support Section
          _buildSectionHeader("সাপোর্ট"),
        Column(
          children: [
            _buildDrawerItem(Icons.email, 'ইমেইল করুন', () {
              _launchEmail(aboutState.about!.email);
            },),
            _buildDrawerItem(Icons.call, "কল করুন", () {
              _dialPhoneNumber(aboutState.about!.phone);
            },),
            _buildDrawerItem(Icons.message, "মেসেজ করুন", () {
              _launchSMS(aboutState.about!.phone);
            },),
          ],
        ),
          const Spacer(),
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
    );
  }

  // Build individual drawer item
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.blue.shade800),
            const SizedBox(width: 10,),
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
          color: Colors.blue,
        ),
      ),
    );
  }

  // Social media button (generic)
  Widget _socialMediaButton(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, size: 28, color: Colors.blue.shade800),
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


  // Support option with icon and text
  Widget _supportOption(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue.shade800),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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

  // Launch SMS
  void _launchSMS(String phoneNo) async {
    final smsUrl = 'sms:$phoneNo';
    if (await canLaunch(smsUrl)) {
      await launch(smsUrl);
    } else {
      throw 'Could not launch SMS';
    }
  }

}
