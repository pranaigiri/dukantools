import 'package:flutter/material.dart';
import 'package:gram_or_price/common/banner_ad.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'This tool is developed for the shopowners to help them on their daily calculation tasks.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Developed By:",
                    style: TextStyle(
                        fontWeight: FontWeight.w100, color: Colors.grey),
                  ),
                  Text("Pranai Giri (The Designer Sikkim)")
                ],
              )),
            ),
          ),
          BannerAdWidget()
        ],
      ),
    );
  }
}
