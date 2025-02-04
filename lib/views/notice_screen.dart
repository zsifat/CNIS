import 'package:chapainawabganjcity/viewmodels/news_viewmodel.dart';
import 'package:chapainawabganjcity/viewmodels/news_category_viewmodel.dart';
import 'package:chapainawabganjcity/views/notice_details.dart';
import 'package:chapainawabganjcity/views/widgets/news_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({super.key});

  @override
  ConsumerState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  bool isOffline = true; // Track internet connection status
  int selectedCategoryIndex = 0; // Track selected category

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _checkInternet();
      ref.read(newsCategoryProvider.notifier).fetchNewsCategories();
      ref.read(newsProvider.notifier).fetchNews(null);
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
    final newsCategoryState = ref.watch(newsCategoryProvider);
    final categories = newsCategoryState.newsCategories;
    final allNews = ref.watch(newsProvider);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'নোটিশ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body:isOffline
          ? _buildNoInternet() : RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async{
          if(selectedCategoryIndex==0){
            ref.read(newsProvider.notifier).fetchNews(null);
          }else{
            ref.read(newsProvider.notifier).fetchNews((categories[selectedCategoryIndex-1].id));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(newsCategoryState.isLoading)
                const LinearProgressIndicator(color: Colors.blue,),
              // Categories List with Smooth Scrolling
              if (categories.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length+1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedCategoryIndex = index);
                          if(index==0){
                            ref.read(newsProvider.notifier).fetchNews(null);
                          }else{
                            ref.read(newsProvider.notifier).fetchNews((categories[index-1].id));
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedCategoryIndex == index ? Colors.blue.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade900, width: 1),
                            boxShadow: selectedCategoryIndex == index
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 6)]
                                : [],
                          ),
                          child: Center(
                            child: Text( index == 0 ? 'All' :
                              categories[index-1].title,
                              style: TextStyle(
                                color: selectedCategoryIndex == index ? Colors.white : Colors.blue.shade900,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if(categories.isEmpty)
                const SizedBox.shrink(),
              const SizedBox(height: 12),

              // Notices List or Empty State
              Expanded(
                child: allNews.when(
                    data: (data) {
                      if(data.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: data.length, // Example count (Replace with real data)
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetailScreen(news: data[index]),));
                            },
                            child: NewsCard(
                              news: data[index],
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                    }, loading: () {
                      return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                    },)
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Beautiful Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/noitem.svg', width: 140, height: 140),
          const SizedBox(height: 16),
          Text(
            'No Notices Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 5),
          Text(
            'Stay tuned for the latest updates!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
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

}
