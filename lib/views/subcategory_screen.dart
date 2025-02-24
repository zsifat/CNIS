
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapainawabganjcity/models/subCategory.dart';
import 'package:chapainawabganjcity/views/DataScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryName;
  final List<SubCategory> subcategories;

  const SubcategoryPage({super.key, required this.categoryName, required this.subcategories});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width > 600 ? 4 : 3, // Responsive grid columns based on screen width
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            return _subcategoryItem(subcategories[index], context, width);
          },
        ),
      ),
    );
  }

  Widget _subcategoryItem(SubCategory subcategory, BuildContext context, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(id: subcategory.categoryId!, title: categoryName,subCategoryId: subcategory.id!.toInt(),),));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                  errorWidget: (context, url, error) {
                    return SvgPicture.asset('assets/images/${subcategory.categoryId}.svg',
                        width: 60, height: 60);
                  },
                  placeholder: (context, url) {
                    return CircularProgressIndicator(
                      color: Colors.green.shade800,
                    );
                  },
                  imageUrl: subcategory.image!,
                  width: 60,
                  height: 60),
              const SizedBox(height: 10),
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                subcategory.title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.04, // Responsive font size
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
