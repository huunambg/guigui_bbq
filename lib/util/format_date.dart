// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormatDate {
  String formatDate1(DateTime inputDate) {
    String formattedDate =
        DateFormat('dd MMM yyyy', Get.locale!.languageCode).format(inputDate);
    return formattedDate;
  }

  String formatDate2(DateTime inputDate) {
    String formattedDate =
        DateFormat('MMMM dd, yyyy', Get.locale!.languageCode).format(inputDate);
    return formattedDate;
  }

  String formatDatePath(DateTime inputDate) {
    String formatDate = DateFormat('yyyy_MM_dd_HH_mm_ss').format(inputDate);
    return formatDate;
  }

  String formatDate(String? date) {
    if (date == null) return "Không xác định";
    try {
      final parsedDate = DateTime.parse(date).add(7.hours);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return "Không xác định";
    }
  }
}
