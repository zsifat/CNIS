import 'package:carousel_slider/carousel_slider.dart';
import 'package:chapainawabganjcity/viewmodels/selected_upazila_provider.dart';
import 'package:chapainawabganjcity/views/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chapainawabganjcity/models/category.dart';
import 'package:chapainawabganjcity/viewmodels/category_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/slider_viewmodel.dart';
import 'package:chapainawabganjcity/models/upazila.dart';
import '../viewmodels/about_viewmodel.dart';
import 'DataScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // Refresh logic
  Future<void> _refreshContent() async {
    await ref.read(categoryNotifierProvider.notifier).fetchCategories();
    await ref.read(sliderViewModelProvider.notifier).fetchSliders();
    await ref.read(aboutViewModelProvider.notifier).fetchAboutData();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryNotifierProvider).categories;
    final sliderImagesState = ref.watch(sliderViewModelProvider);
    final int selectedUpazilaFilterIndex = ref.watch(selectedUpazilaProvider);
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;
    double padding = mediaQuery.size.width * 0.03;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Chapainawabganj City',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _refreshContent, // Trigger the refresh action
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel Slider with Dot Indicator
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: height * 0.3,
                  child: Column(
                    children: [
                      sliderImagesState.isLoading
                          ? const LinearProgressIndicator(color: Colors.blue)
                          : Expanded(
                        child: CarouselSlider.builder(
                          itemCount: sliderImagesState.sliders.length,
                          itemBuilder: (context, index, realIndex) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: sliderImagesState.sliders[index].thumb,
                                placeholder: (context, url) => const Center( // Center the CircularProgressIndicator
                                  child: CircularProgressIndicator(color: Colors.blue,), // Simply place it at the center
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1.0,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildIndicator(sliderImagesState.sliders.length),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'আপনার উপজেলা পছন্দ করুন',
                  style: TextStyle(
                    fontSize: width * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Upazila.values.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            setState(() {
                              ref.read(selectedUpazilaProvider.notifier).setUpazila(index);
                            });
                          },
                          child: SizedBox(
                            width: 110,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              color: selectedUpazilaFilterIndex == index
                                  ? Colors.blue.shade800
                                  : Colors.transparent,
                              child: Center(
                                child: Text(
                                  Upazila.values[index].name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: selectedUpazilaFilterIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Section Heading
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _sectionHeading('প্রয়োজনীয় সেবা'),
                ),

                // Grid View for Categories
                _gridviewWidget(categories, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dot Indicator for the carousel
  Widget _buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentIndex == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? Colors.blue : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  // Grid View Widget for categories
  Widget _gridviewWidget(List<Category> categories, double width) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(id:category.id.toString(),title: category.title,)));
            },
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CachedNetworkImage(
                    errorWidget: (context, url, error) {
                      return SvgPicture.asset('assets/images/${category.id}.svg',width: 45, height: 45 );
                    },
                    placeholder: (context, url) {
                      return CircularProgressIndicator(color: Colors.blue.shade800,);
                    },
                    imageUrl:category.thumb,width: 45, height: 45 ),

                const SizedBox(height: 14),
                Text(
                  category.title,
                  style: TextStyle(
                    fontSize: width * 0.04, // Responsive font size
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Section Heading Widget
  Widget _sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

