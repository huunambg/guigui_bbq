import 'dart:convert';

import 'package:http/http.dart' as http;
import '/model/acount.dart';
import '/model/class.dart';
import '/model/grade.dart';
import '/model/grade_with_student.dart';
import '/model/student.dart';
import '/model/subject.dart';

class ApiService {
  final String baseUrl;
  ApiService()
      : baseUrl =
            "http://192.168.43.8:3000/public/api"; // Thay bằng URL của bạn

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
      throw "Lỗi kết nối tới máy chủ.";
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
      throw "Unable to connect to server. Please check your internet connection.";
    }
  }

  Future<List<Class>> getListClassByTeacher(
      int teacherId, String accessToken) async {
    final url = Uri.parse('$baseUrl/get-class-by-teacher/$teacherId');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "authorization": "Beaer $accessToken"
        },
      );
      print("getListClassByTeacher ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Class> listClass = listData
            .map(
              (e) => Class.fromJson(e),
            )
            .toList();
        return listClass;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }

  Future<List<Student>> getStudentByClass(
      int classId, String accessToken) async {
    final url = Uri.parse('$baseUrl/get-student-by-class/$classId');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "authorization": "Beaer $accessToken"
        },
      );
      print("getStudentByClass ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Student> listStudent = listData
            .map(
              (e) => Student.fromJson(e),
            )
            .toList();
        return listStudent;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }

  Future<List<Subject>> getSubject(String accessToken) async {
    final url = Uri.parse('$baseUrl/get-all-subject');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "authorization": "Beaer $accessToken"
        },
      );
      print("getSubject ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Subject> listSubject = listData
            .map(
              (e) => Subject.fromJson(e),
            )
            .toList();
        return listSubject;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }

  Future<List<Grade>> getGradeByClassAndStudent(
      int classId, int studentId, String accessToken) async {
    final url = Uri.parse('$baseUrl/get-grade-by-class-and-student');
    print(url);
    try {
      final response = await http.post(url,
          headers: {"authorization": "Beaer $accessToken"},
          body: {"class_id": "$classId", "student_id": "$studentId"});
      print("getStudentByClass ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<Grade> listGrade = listData
            .map(
              (e) => Grade.fromJson(e),
            )
            .toList();
        return listGrade;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }

    Future<List<GradeWithStudent>> getGradeBySubjectClass(
      int classId, int subjectId, String accessToken) async {
    final url = Uri.parse('$baseUrl/get-grade-subject-class');
    print(url);
    try {
      final response = await http.post(url,
          headers: {"authorization": "Beaer $accessToken"},
          body: {"class_id": "$classId", "subject_id": "$subjectId"});
      print("getStudentByClass ${jsonDecode(response.body)['data']}");
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonDecode(response.body)['data'];
        List<GradeWithStudent> listGrade = listData
            .map(
              (e) => GradeWithStudent.fromJson(e),
            )
            .toList();
        return listGrade;
      } else {
        throw "Tài khoản hoặc mật khẩu không chính xác!.";
      }
    } catch (e) {
      print("Network error: $e");
      throw "Lỗi kết nối tới máy chủ.";
    }
  }
}
