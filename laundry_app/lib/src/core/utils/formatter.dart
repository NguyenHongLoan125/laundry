class CurrencyFormatter {
  static String format(double amount) {
    return '${amount.toStringAsFixed(3).replaceAll('.', ',')}đ';
  }
}

class DateFormatter {
  static String formatDate(String date) {
    // Implement date formatting logic
    return date;
  }
}