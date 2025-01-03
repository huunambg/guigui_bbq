import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/model/transaction.dart';
import '/model/acount.dart';

class ApiService {
  final String baseUrl;
  ApiService()
      : baseUrl =
            "http://192.168.20.72:3000/public/api"; // Thay bằng URL của bạn

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
      throw "Lỗi kết nối tới máy chủ.";
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
