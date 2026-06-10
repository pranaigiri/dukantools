import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode') ?? 'en';
      _locale = Locale(languageCode);
      notifyListeners();
    } catch (_) {
      // Fallback in case SharedPreferences is not initialized yet
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'hi'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', locale.languageCode);
    } catch (_) {}
  }
}
