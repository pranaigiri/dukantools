import 'package:flutter/material.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/main.dart';

import '../models/item.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const HomePage();
    } else {
      try {
        final Item item = ModalRoute.of(context)!.settings.arguments as Item;
        Widget currentWidget = item.widget;

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
            backgroundColor: item.color,
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarTextStyle: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white, // Sets the color of the title
                fontSize: 20,
              ),
            ).bodyMedium,
            titleTextStyle: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white, // Sets the color of the title
                fontSize: 20,
              ),
            ).titleLarge,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: currentWidget,
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BannerAdWidget(),
        );
      } catch (e) {
        throw const CircularProgressIndicator();
      }
    }
  }
}
