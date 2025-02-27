import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/viewmodels/states/doctors_state.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:chapainawabganjcity/views/widgets/data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../models/subCategory.dart';
import '../viewmodels/data_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedIndex=widget.subcategories.first.id!.toInt();
    // TODO: implement initState
    Future.microtask(
      () => ref.read(dataNotifierProvider.notifier).fetchData(widget.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataState = ref.watch(dataNotifierProvider);
    final int selectedUpazilaFilterIndex = ref.watch(selectedUpazilaProvider);
    final filteredDataList = dataState.dataList.where(
      (element) {
        bool departmentMatch = int.parse(element.department) == _selectedIndex;
        bool upazilaMatch =
            selectedUpazilaFilterIndex == 0 || element.upazila == selectedUpazilaFilterIndex;

        return departmentMatch && upazilaMatch;
      },
    ).toList();

    return Scaffold(
      appBar: buildAppBar(widget.title),
      body: Column(
        children: [
          Row(
            children: [
              _buildOption(widget.subcategories.first),
              _buildOption(widget.subcategories.last),
            ],
          ),
          Expanded(child: _buildNewProductContent(dataState, filteredDataList)),
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
      itemCount: filteredDataList.length,
      itemBuilder: (context, index) {
        Data data = filteredDataList[index];
        return DataCard(
          data: data,
        );
      },
    );
  }


}
