import 'package:intl/intl.dart';

String priceFormatter(double price) {
  return NumberFormat.currency(
    symbol: '',
    decimalDigits: 0,
  ).format(price);
}
