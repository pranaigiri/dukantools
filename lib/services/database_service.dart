import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static const String plBoxName = 'p_and_l_box';
  static const String ledgerBoxName = 'ledger_box';
  static const String shopsBoxName = 'shops_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(plBoxName);
    await Hive.openBox(ledgerBoxName);
    await Hive.openBox(shopsBoxName);
  }

  static Box get plBox => Hive.box(plBoxName);
  static Box get ledgerBox => Hive.box(ledgerBoxName);
  static Box get shopsBox => Hive.box(shopsBoxName);

  static Future<void> clearAll() async {
    await plBox.clear();
    await ledgerBox.clear();
    await shopsBox.clear();
  }
}
