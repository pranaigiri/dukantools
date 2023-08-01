class Helper {
  String formatDouble(double value) {
    String formattedValue = value.toStringAsFixed(3);

    if (formattedValue.contains('.') && formattedValue.endsWith('0')) {
      formattedValue = formattedValue.replaceAll(RegExp(r'0+$'), '');
      formattedValue = formattedValue.replaceAll(RegExp(r'\.$'), '');
    }

    return formattedValue;
  }
}
