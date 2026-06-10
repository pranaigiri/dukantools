import 'package:flutter/material.dart';
import 'package:dukan_tools/common/version_code.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  final _versionCode = VersionCode();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/icons/dukan_tools_logo.png',
              width: 80,
              height: 80,
            ),
            Text(
              l10n.dukanTools,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              l10n.allInOneGoodsFinanceCalculator,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            FutureBuilder<String>(
              future: _versionCode.getVersionCode(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(l10n.errorLoadingVersion);
                } else {
                  return Text('${l10n.version}: ${snapshot.data}',
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
            Text(
              l10n.thisToolIsDevelopedForTheShopownersToHelpThemOnTheirDailyCalculationTasks,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              l10n.developedBy,
              style: const TextStyle(fontWeight: FontWeight.w100, color: Colors.grey),
            ),
            Text(l10n.pranaiGiriTheDesignerSikkim)
          ],
        )),
      ),
    );
  }
}
