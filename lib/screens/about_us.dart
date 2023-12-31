import 'package:flutter/material.dart';
import 'package:shop_tools/common/version_code.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  final _versionCode = VersionCode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/icons/shop_tools_logo.png',
              width: 80,
              height: 80,
            ),
            const Text(
              "Shop Tools",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              "All in One - Goods & Finance Calculator",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            FutureBuilder<String>(
              future: _versionCode.getVersionCode(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading version');
                } else {
                  return Text('Version: ${snapshot.data}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w100, color: Colors.grey));
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 0.5,
            ),
            const Text(
              'This tool is developed for the shopowners to help them on their daily calculation tasks.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Developed By:",
              style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey),
            ),
            const Text("Pranai Giri (The Designer Sikkim)")
          ],
        )),
      ),
    );
  }
}
