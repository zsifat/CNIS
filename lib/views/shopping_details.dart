import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/viewmodels/states/doctors_state.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:chapainawabganjcity/views/widgets/data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../feature/data_add/presentation/view/data_add_screen.dart';
import '../models/subCategory.dart';
import '../viewmodels/data_viewmodel.dart';
import '../viewmodels/search_text_viewmodel.dart';
import '../viewmodels/selected_upazila_provider.dart';

class ShoppingDetailsScreen extends ConsumerStatefulWidget {
  final int id;
  final String title;
  final List<SubCategory> subcategories;

  const ShoppingDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.subcategories,
  });

  @override
  ConsumerState<ShoppingDetailsScreen> createState() => _ShoppingDetailsScreenState();
}

class _ShoppingDetailsScreenState extends ConsumerState<ShoppingDetailsScreen> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _selectedIndex=widget.subcategories.last.id!.toInt();
    Future.microtask(
      () => ref.read(dataNotifierProvider.notifier).fetchData(widget.id.toString()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final searchText = ref.watch(searchTextProvider);
    final dataState = ref.watch(dataNotifierProvider);
    final int selectedUpazilaFilterIndex = ref.watch(selectedUpazilaProvider);
    final filteredDataList = dataState.dataList.where(
      (element) {
        bool departmentMatch = int.parse(element.department!) == _selectedIndex;
        bool upazilaMatch =
            selectedUpazilaFilterIndex == 0 || element.upazila == selectedUpazilaFilterIndex;

        return departmentMatch && upazilaMatch;
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

    String? marqueeText;
    if (widget.id == 4) {
      marqueeText = "প্রতারক হতে সতকর্তা অবলম্বন করুন। নিজ দায়িত্বে যাচাই করে রক্তদান করুন। সচেতনতায় চাঁপাইনবাবগঞ্জ ইনফরমেশন সার্ভিস (CNIS)। ";
    }

    return Scaffold(
      appBar: buildAppBar(widget.title),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
        onPressed: () {
          Get.to(InputFormScreen(catId: widget.id.toString(),subCatId: _selectedIndex.toString(),));
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              _buildOption(widget.subcategories.last),
              _buildOption(widget.subcategories.first),
            ],
          ),
          const SizedBox(height: 10,),
          if(marqueeText!=null)
            SizedBox(
              height: 30,
              width: double.infinity,
              child: Marquee(
                text: marqueeText,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green.shade800),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 60.0,
                startPadding: 10.0,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SearchBar(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(0),
              controller: _searchController,
              hintText: 'সার্চ করুন',
              leading: const Icon(Icons.search),
              trailing: [
                InkWell(
                    onTap: () {
                      _searchController.clear(); // Clear the controller text
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
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(child: _buildNewProductContent(dataState, searchFilteredDataList)),
        ],
      ),
    );
  }

  Widget _buildOption(SubCategory subcategory) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = subcategory.id!.toInt();
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                subcategory.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedIndex == subcategory.id!.toInt() ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == subcategory.id!.toInt() ? Colors.green.shade800 : Colors.black,
                ),
              ),
            ),
            Container(
              height: 3,
              width: double.infinity,
              color: _selectedIndex == subcategory.id!.toInt() ? Colors.green.shade800 : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProductContent(DataState dataState, List<Data> filteredDataList) {
    if (dataState.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    if (filteredDataList.isEmpty) {
      return Center( // ✅ Removed Expanded
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/noitem.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  'তথ্য পাওয়া যায়নি',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: filteredDataList.length,
      itemBuilder: (context, index) {
        Data data = filteredDataList[index];
        return DataCard(
          data: data,
          categoryId: widget.id.toString(),
        );
      },
    );
  }


}
