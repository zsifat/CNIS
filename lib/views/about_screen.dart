import 'package:chapainawabganjcity/viewmodels/about_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/states/aboutState.dart';
import 'package:chapainawabganjcity/views/advertisement_screen.dart';
import 'package:chapainawabganjcity/views/main_screen.dart';
import 'package:chapainawabganjcity/views/notice_screen.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  final TextStyle textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutState = ref.watch(aboutViewModelProvider);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar('CNIS'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFE9FAF8)
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo-CNIS.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 6,),
                  const Expanded(
                      child: Text(
                    'Chapainawabganj Information Service',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ))
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoCards('২৪ ঘণ্টা\nসাপোর্ট', Icons.support_agent, size),
                buildInfoCards('সকল সেবা\nএক অ্যাপে', Icons.android, size),
                buildInfoCards('আমাদের\nসাথে থাকুন', CupertinoIcons.link, size)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            buildItems(
              'হোম',
              Icons.home,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'বিজ্ঞাপন দিন',
              Icons.newspaper,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvertisementScreen(),
                    ));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'নোটিশ',
              Icons.campaign,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoticeScreen(),
                    ));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'যোগাযোগ করুন',
              Icons.support_agent,
              () {
                _dialPhoneNumber(aboutState.about!.phone);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'ফেসবুক গ্রুপ',
              FontAwesomeIcons.facebook,
              () {
                _launchUrl(aboutState.about!.facebook);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'ইন্সটাগ্রাম',
              FontAwesomeIcons.instagram,
              () {
                _launchUrl(aboutState.about!.instagram);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'লিঙ্কডইন',
              FontAwesomeIcons.linkedin,
              () {
                _launchUrl(aboutState.about!.linkdin);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            buildItems(
              'টুইটার',
              FontAwesomeIcons.twitter,
              () {
                _launchUrl(aboutState.about!.twitter);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItems(String title, IconData iconData, Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration:
            BoxDecoration(color: const Color(0xFFE9FAF8), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Icon(
                iconData,
                color: Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              title,
              style: textStyle.copyWith(fontSize: 16),
            )),
            const Icon(CupertinoIcons.right_chevron)
          ],
        ),
      ),
    );
  }

  Container buildInfoCards(String title, IconData icon, Size size) {
    return Container(
      height: 60,
      width: size.width * 0.3,
      decoration:
          BoxDecoration(color: const Color(0xFFE9FAF8), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon),
          Text(
            title,
            style: textStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
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
  } else {}
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        ],
      ),
    ),
  );
}
