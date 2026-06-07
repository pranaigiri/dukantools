import 'package:flutter/material.dart';
import 'package:dukan_tools/screens/main_navigation_shell.dart';
import 'package:dukan_tools/models/item.dart';
import 'package:dukan_tools/widgets/banner_ad_widget.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const MainNavigationShell();
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
      } catch (e, stack) {
        debugPrint('ERROR in ItemDetails.build: $e\n$stack');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    }
  }
}
