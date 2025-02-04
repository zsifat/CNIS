import 'package:chapainawabganjcity/viewmodels/about_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/advertisement_viewodel.dart';
import 'package:chapainawabganjcity/views/notice_details.dart';
import 'package:chapainawabganjcity/views/widgets/news_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementScreen extends ConsumerStatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  ConsumerState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends ConsumerState<AdvertisementScreen> {
  bool isOffline = true; // Track internet connection status

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      _checkInternet();
      ref.read(advertisementProvider.notifier).fetchAdvertisement();
    },);

  }

  // Function to check internet connectivity
  void _checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult.contains(ConnectivityResult.none);
    });

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOffline = result.contains(ConnectivityResult.none);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final advertisements = ref.watch(advertisementProvider);
    final aboutState = ref.watch(aboutViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'বিজ্ঞাপন',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: isOffline
          ? _buildNoInternet() : SingleChildScrollView(
        child: Column(
          children: [
            // Top part with the logo and contact icons
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo-CNIS.png', scale: 12),
                  Text(
                    textAlign: TextAlign.center,
                    "যেকোনো ধরনের প্রতিষ্ঠান বা পণ্যের বিজ্ঞাপন দিতে যোগাযোগ করুন",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContactIcon(Icons.email, "Email", () {
                        _launchEmail(aboutState.about!.email);
                      }),
                      const SizedBox(width: 40),
                      _buildContactIcon(Icons.phone, "Call", () {
                        _dialPhoneNumber(aboutState.about!.phone);
                      }),
                      const SizedBox(width: 40),
                      _buildContactIcon(Icons.message, "Message", () {
                        _launchSMS(aboutState.about!.phone);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            // List of advertisements
            advertisements.when(
              data: (ads) {
                if (ads.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return ListView.separated(
                    shrinkWrap: true,  // Makes the ListView behave like a non-scrolling widget
                    physics: const NeverScrollableScrollPhysics(), // Disable its own scrolling
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(news: ads[index]),));
                          },
                          child: NewsCard(news: ads[index]));
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: ads.length,
                  );
                }
              },
              error: (error, stackTrace) {
                return const Center(child: LinearProgressIndicator(color: Colors.blue,));
              },
              loading: () {
                return const Center(child: LinearProgressIndicator(color: Colors.blue,));
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget to show when there's no internet
  Widget _buildNoInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 5),
          Text(
            'Please check your internet and try again!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
// Helper method for building tappable icons
  Widget _buildContactIcon(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, size: 30, color: Colors.blue.shade900),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.blue.shade900, fontSize: 14),
        ),
      ],
    );
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

// Launch SMS
void _launchSMS(String phoneNo) async {
  final smsUrl = 'sms:$phoneNo';
  if (await canLaunch(smsUrl)) {
    await launch(smsUrl);
  } else {
    throw 'Could not launch SMS';
  }
}

