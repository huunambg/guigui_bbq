import 'package:intl/intl.dart';
  String tienviet(int number) {
    final formatCurrency =
        new NumberFormat.currency(locale: "vi_VN", symbol: "Đ");
    return formatCurrency.format(number);
  }