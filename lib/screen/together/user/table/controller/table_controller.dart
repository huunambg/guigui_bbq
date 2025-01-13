import 'package:get/get.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/services/api.dart';

class TableController extends GetxController {
  RxList<Tablee> listTable = <Tablee>[].obs;

  void getListTable() async {
    listTable.value = await ApiService().getAllTable();
  }
}
