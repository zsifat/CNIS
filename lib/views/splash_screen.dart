import 'package:chapainawabganjcity/viewmodels/about_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/category_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/slider_viewmodel.dart';
import 'package:chapainawabganjcity/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data asynchronously after the widget tree is done building
    Future.microtask(() => fetchAllData());
  }

  // Fetch categories, sliders, and about data asynchronously
  fetchAllData() async {
    // Show a loading indicator while the data is being fetched
    await ref.read(categoryNotifierProvider.notifier).fetchCategories();
    await ref.read(sliderViewModelProvider.notifier).fetchSliders();
    await ref.read(aboutViewModelProvider.notifier).fetchAboutData();

    // Navigate to HomeScreen once the data has been fetched
    if(context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image
            Image.asset(
              'assets/images/logo-CNIS.png', // Adjust the image path as necessary
              width: 200, // Adjust the width as per your design
              height: 200, // Adjust the height as per your design
            ),
            const SizedBox(height: 20), // Spacing between the logo and progress indicator
            // Progress indicator to show loading status
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                color: Colors.blue.shade800, // Customize color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
