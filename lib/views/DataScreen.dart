import 'package:chapainawabganjcity/feature/data_add/presentation/view/data_add_screen.dart';
import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/models/subCategory.dart';
import 'package:chapainawabganjcity/models/upazila.dart';
import 'package:chapainawabganjcity/viewmodels/data_viewmodel.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:chapainawabganjcity/views/widgets/data_card.dart';
import 'package:chapainawabganjcity/views/widgets/data_card_second_version.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../viewmodels/search_text_viewmodel.dart';
import '../viewmodels/selected_upazila_provider.dart';

class DataScreen extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final SubCategory? subCategory;

  const DataScreen({super.key, required this.id, required this.title, this.subCategory});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  bool isOffline = true;

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
  void initState() {
    super.initState();
    // TODO: implement initState
    _checkInternet();
    Future.microtask(
      () => ref.read(dataNotifierProvider.notifier).fetchData(widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedUpazilaFilterIndex = ref.watch(selectedUpazilaProvider);
    final dataState = ref.watch(dataNotifierProvider);
    final searchText = ref.watch(searchTextProvider);
    final subCategories = dataState.dataList
        .map(
          (e) => e.department,
        )
        .toSet();
    final filteredDataList = dataState.dataList.where(
      (element) {
        if (widget.subCategory != null) {
          // Check if department is not null before comparing, or handle null safely
          return (element.department != null &&
                  element.department!.isNotEmpty &&
                  int.parse(element.department!) == widget.subCategory!.id!.toInt()) &&
              (selectedUpazilaFilterIndex == 0 || element.upazila == selectedUpazilaFilterIndex);
        }
        return selectedUpazilaFilterIndex == 0 || element.upazila == selectedUpazilaFilterIndex;
      },
    ).toList();

    List<Data> searchFilteredDataList = filteredDataList.where(
      (element) {
        if (searchText.isNotEmpty) {
          if (element.degree != null) {
            return (element.details.toLowerCase().contains(searchText) ||
                element.title.toLowerCase().contains(searchText) ||
                element.degree!.toLowerCase().contains(searchText));
          }
          return (element.details.toLowerCase().contains(searchText) ||
              element.title.toLowerCase().contains(searchText));
        }
        return true;
      },
    ).toList();

    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;

    String? marqueeText;
    if (widget.id == '13') {
      marqueeText =
          "চাপাইনবাবগঞ্জ ইনফরমেশন সার্ভিস (CNIS) অ্যাপে প্রকাশিত চাকরির তথ্য সংশ্লিষ্ট নিয়োগকারী প্রতিষ্ঠান কর্তৃক প্রদান করা হয়। নিয়োগ প্রক্রিয়া ও দায়িত্ব সম্পূর্ণভাবে সংশ্লিষ্ট প্রতিষ্ঠানগুলোর। এ বিষয়ে কোনো লেনদেন বা দায়িত্বের সাথে CNIS অ্যাপ সংশ্লিষ্ট নয়।";
    } else if (['1', '2', '10', '15'].contains(widget.id)) {
      marqueeText =
          "চাপাইনবাবগঞ্জ ইনফরমেশন সার্ভিস (CNIS) অ্যাপে প্রকাশিত সকল তথ্য সংশ্লিষ্ট ব্যাক্তি বা প্রতিষ্ঠান কর্তৃক প্রদান করা হয়। কোনো ধরনের লেনদেন বা দায়িত্বের সাথে CNIS অ্যাপ সংশ্লিষ্ট নয়।";
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(searchTextProvider.notifier).clearSearchText();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade800,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 36,
          ),
          onPressed: () {
            Get.to(InputFormScreen(catId: widget.id,subCatId: widget.subCategory?.id.toString(),));
          },
        ),
        appBar: buildAppBar(widget.title),
        body: isOffline
            ? buildNoInternet()
            : Padding(
                padding: EdgeInsets.all(width * 0.03), // Dynamic padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (marqueeText != null)
                      SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: Marquee(
                          text: marqueeText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.green.shade800),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 60.0,
                          startPadding: 10.0,
                        ),
                      ),
                    const SizedBox(height: 4),
                    SearchBar(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all(0),
                      hintText: 'Search',
                      leading: const Icon(Icons.search),
                      trailing: [
                        InkWell(
                            onTap: () {
                              ref.read(searchTextProvider.notifier).clearSearchText();
                            },
                            child: const Icon(Icons.clear)),
                      ],
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.grey))),
                      onChanged: (value) {
                        ref.read(searchTextProvider.notifier).updateSearchText(value);
                      },
                      onSubmitted: (value) {
                        ref.read(searchTextProvider.notifier).updateSearchText(value);
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    dataState.isLoading
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator(color: Colors.green)))
                        : searchFilteredDataList.isEmpty
                            ? Expanded(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/noitem.svg',
                                    width: 100,
                                    height: 100,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Center(
                                      child: Text(
                                    'তথ্য পাওয়া যায়নি',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  )),
                                ],
                              ))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: searchFilteredDataList.length,
                                  itemBuilder: (context, index) {
                                    Data data = searchFilteredDataList[index];
                                    return DataCard(
                                      data: data,
                                      categoryId: data.catId,
                                      subcategory: widget.subCategory,
                                    );
                                  },
                                ),
                              ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildNoInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Internet Connection',
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
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
