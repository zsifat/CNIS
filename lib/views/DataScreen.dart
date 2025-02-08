import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/models/upazila.dart';
import 'package:chapainawabganjcity/viewmodels/data_viewmodel.dart';
import 'package:chapainawabganjcity/views/widgets/data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../viewmodels/selected_upazila_provider.dart';

class DataScreen extends ConsumerStatefulWidget {
  final String id;
  final String title;

  const DataScreen({super.key, required this.id, required this.title});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  String selectedSubcategory = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Future.microtask(
      () => ref.read(dataNotifierProvider.notifier).fetchData(widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedUpazilaFilterIndex = ref.watch(selectedUpazilaProvider);
    final dataState = ref.watch(dataNotifierProvider);
    final subCategories = dataState.dataList
        .map(
          (e) => e.department,
        )
        .toSet();
    final filteredDataList = dataState.dataList.where(
      (element) {
        if(selectedSubcategory.isEmpty && selectedUpazilaFilterIndex ==0){
          return true;
        }else if(selectedSubcategory.isEmpty && selectedUpazilaFilterIndex !=0){
          return element.upazila == selectedUpazilaFilterIndex;
        }
        return element.department == selectedSubcategory && element.upazila == selectedUpazilaFilterIndex;
      },
    ).toList();
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.03), // Dynamic padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'ফিল্টার করুন (${Upazila.values[selectedUpazilaFilterIndex].name} উপজেলা)',
              style: TextStyle(
                fontSize: width * 0.05, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: DropdownMenu(
                width: width,
                  menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
                  initialSelection: selectedSubcategory,
                  hintText: 'সকল ধরন',
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSubcategory = value;
                      });
                    }
                  },
                  dropdownMenuEntries: [
                    ...subCategories.map(
                      (e) => DropdownMenuEntry(value: e, label: e),
                    )
                  ]),
            ),
            const SizedBox(height: 10),
            dataState.isLoading
                ? const LinearProgressIndicator(color: Colors.blue)
                : dataState.dataList.isEmpty
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
                          itemCount: filteredDataList.length,
                          itemBuilder: (context, index) {
                            Data data = filteredDataList[index];
                            return DataCard(
                              department: data.department,
                              details: data.details,
                              thumb: data.thumb,
                              title: data.title,
                              contact: data.contact,
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
