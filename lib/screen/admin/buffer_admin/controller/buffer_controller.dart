import 'package:get/get.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/services/api.dart';

class BufferController extends GetxController {
  RxList<Buffer> listBuffer = <Buffer>[].obs;

  void loadData() {
    listBuffer.value = Get.find<AddTransactionController>().listBuffer;
  }

  void getListBuffer() async {
    listBuffer.value = await ApiService().getAllBuffer();
  }

  Future<void> deleteBuffer(int id) async {
    await ApiService().deleteBuffer(id);

    int index = listBuffer.indexWhere(
      (element) => element.bufferId == id,
    );

    if (index != -1) {
      listBuffer.removeAt(index);
    }
  }

  Future<void> updateBuffer(Buffer buffer) async {
    await ApiService().updateBuffer(buffer);
    int index = listBuffer.indexWhere(
      (element) => element.bufferId == buffer.bufferId,
    );
    listBuffer[index] = buffer;
  }
}
