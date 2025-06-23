import 'package:chapainawabganjcity/feature/profile/presentation/views/about_screen.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('প্যাকেজ') ,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Lottie animation for the image
            Container(
              height: 250,
              child: Lottie.asset('assets/lottie/payment.json'), // Use the appropriate Lottie file
            ),
            SizedBox(height: 30),

            // Package selection buttons
            PackageButton(
              title: '৭ দিন',
              price: '100',
              description: 'অনলিমিটেড অ্যাড',
              color: Colors.purple,
              iconPath: 'assets/images/normal.svg',
            ),
            SizedBox(height: 16),
            PackageButton(
              title: '১৫ দিন',
              price: '150',
              description:  'অনলিমিটেড অ্যাড',
              color: Colors.green,
              iconPath: 'assets/images/silver.svg',
            ),
            SizedBox(height: 16),
            PackageButton(
              title: '৩০ দিন',
              price: '300',
              description:  'অনলিমিটেড অ্যাড',
              color: Colors.teal,
              iconPath: 'assets/images/gold.svg',
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
               showCustomGreenSnackBar(context,title: 'বর্তমানে সম্পূর্ণ ফ্রি');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('পেমেন্ট করুন', style: TextStyle(fontSize: 16,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageButton extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final Color color;
  final String iconPath;

  const PackageButton({
    required this.title,
    required this.price,
    required this.description,
    required this.color,
    required this.iconPath
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SvgPicture.asset(iconPath,width: 30,height: 30,),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text(description, style: TextStyle(color: color)),
              ],
            ),
            Spacer(),
            Text('$price টাকা', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
