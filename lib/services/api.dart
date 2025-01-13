import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/model/transaction.dart';
import '/model/acount.dart';

class ApiService {
  final String baseUrl;
  ApiService()
      : baseUrl =
            "http://192.168.20.74:3000/public/api"; // Thay bằng URL của bạn

  Future<dynamic> login(Account account) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(account.toJson()),
      );
      print("login $response");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      // Lỗi mạng hoặc các lỗi không xác định
      print("Network error: $e");
      throw e.toString();
    }
  }

  Future<dynamic> register(Account account) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(account.toJson()),
      );
      return response;
    } catch (e) {
      // Lỗi mạng hoặc các lỗi không xác định
      print("Network error: $e");
      throw e.toString();
    }
  }

  Future<int> addOrder(Orders order) async {
    final url = Uri.parse('$baseUrl/add-order');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
      return jsonDecode(response.body)['insert_id'] as int;
    } catch (e) {
      print("addOrder: $e");
      throw e.toString();
    }
  }

  Future<void> addOrderDetail(OrderDetail orderDetail) async {
    final url = Uri.parse('$baseUrl/add-order-detail');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(orderDetail.toJson()),
      );
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
    } catch (e) {
      print("addOrderDetail: $e");
      throw e.toString();
    }
  }

  Future<void> updateOrderDetail(OrderDetail orderDetail) async {
    final url = Uri.parse('$baseUrl/update-order-detail');
    print(orderDetail.toJsonUpdate());
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(orderDetail.toJsonUpdate()),
      );
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
    } catch (e) {
      print("updateOrderDetail: $e");
      throw e.toString();
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final url = Uri.parse('$baseUrl/update-transaction');
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(transaction.toJsonUpdate()),
      );
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
    } catch (e) {
      print("updateTransaction: $e");
      throw e.toString();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final url = Uri.parse('$baseUrl/add-transaction');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(transaction.toJson()),
      );
      print(jsonEncode(transaction.toJson()));
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
    } catch (e) {
      print(url);
      print("addTransaction: $e");
      throw e.toString();
    }
  }

  Future<void> deleteOrderDetail(int orderDetailId) async {
    final url = Uri.parse('$baseUrl/delete-order-detail/$orderDetailId');
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode != 200) {
        throw "Error: ${response.body}";
      }
    } catch (e) {
      print(url);
      print("deleteOrderDetail: $e");
      throw e.toString();
    }
  }

  Future<String?> uploadAvatar(File? _selectedImage, int userId) async {
    final url = Uri.parse('$baseUrl/upload-avatar/$userId');
    if (_selectedImage == null) return null;

    final request = http.MultipartRequest('POST', url)
      ..files.add(
          await http.MultipartFile.fromPath('avatar', _selectedImage.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['url'];
    }
    return null;
  }

  // Future<List<Class>> getListClassByTeacher(
  //     int teacherId, String accessToken) async {
  //   final url = Uri.parse('$baseUrl/get-class-by-teacher/$teacherId');
  //   print(url);
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "authorization": "Beaer $accessToken"
  //       },
  //     );
  //     print("getListClassByTeacher ${jsonDecode(response.body)['data']}");
  //     if (response.statusCode == 200) {
  //       List<dynamic> listData = jsonDecode(response.body)['data'];
  //       List<Class> listClass = listData
  //           .map(
  //             (e) => Class.fromJson(e),
  //           )
  //           .toList();
  //       return listClass;
  //     } else {
  //       throw "Tài khoản hoặc mật khẩu không chính xác!.";
  //     }
  //   } catch (e) {
  //     print("Network error: $e");
  //     throw "Lỗi kết nối tới máy chủ.";
  //   }
  // }
  Future<List<Transaction>> getAllTransaction() async {
    final url = Uri.parse('$baseUrl/get-all-transaction');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllTransaction ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Transaction> listTransaction = listData
            .map(
              (e) => Transaction.fromJson(e),
            )
            .toList();
        return listTransaction.reversed.toList();
      } else {
        throw response.body;
      }
    } catch (e) {
      print("getAllTransaction: $e");
      throw e.toString();
    }
  }

  Future<List<Tablee>> getAllTable() async {
    final url = Uri.parse('$baseUrl/get-all-table');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllTable ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Tablee> listTablee = listData
            .map(
              (e) => Tablee.fromJson(e),
            )
            .toList();
        return listTablee.reversed.toList();
      } else {
        throw response.body;
      }
    } catch (e) {
      print("getAllTablee: $e");
      throw e.toString();
    }
  }

  Future<List<Menu>> getAllMenu() async {
    final url = Uri.parse('$baseUrl/get-all-menu');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllMenu ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Menu> listMenu = listData
            .map(
              (e) => Menu.fromJson(e),
            )
            .toList();
        return listMenu;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw e.toString();
    }
  }

  Future<List<OrderDetail>> getOrderDetailByOrder(int orderId) async {
    final url = Uri.parse('$baseUrl/get-all-order-by-order/$orderId');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllOrderDetail ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<OrderDetail> listOrderDetail = listData
            .map(
              (e) => OrderDetail.fromJson(e),
            )
            .toList();
        return listOrderDetail;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("getOrderDetailByOrder: $e");
      throw e.toString();
    }
  }

  Future<Transaction> getLastTransactionByTable(int tableId) async {
    final url = Uri.parse('$baseUrl/get-last-transaction-by-table/$tableId');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllTransaction ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Transaction transaction = Transaction.fromJson(data);
        return transaction;
      } else {
        throw response.body;
      }
    } catch (e) {
      print("getLastTransactionByTable: $e");
      throw e.toString();
    }
  }

  Future<List<Buffer>> getAllBuffer() async {
    final url = Uri.parse('$baseUrl/get-all-buffer');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("getAllBuffer ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Buffer> listBuffer = listData
            .map(
              (e) => Buffer.fromJson(e),
            )
            .toList();
        return listBuffer;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }
}
