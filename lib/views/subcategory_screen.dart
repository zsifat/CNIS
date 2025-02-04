
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryName;
  final List<String> subcategories;

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
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width > 600 ? 4 : 3, // Responsive grid columns based on screen width
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            return _subcategoryItem(subcategories[index], context, width);
          },
        ),
      ),
    );
  }

  Widget _subcategoryItem(String subcategory, BuildContext context, double width) {
    return GestureDetector(
      onTap: () {
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
              SvgPicture.asset(
                'assets/images/16.svg',
                width: width * 0.15, // Responsive icon size
                height: width * 0.15, // Responsive icon size
              ),
              const SizedBox(height: 10),
              Text(
                subcategory,
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
