class Student {
  int? studentId;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? address;
  int? classId;

  Student(
      {this.studentId,
      this.fullName,
      this.dateOfBirth,
      this.gender,
      this.address,
      this.classId});

  Student.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    address = json['address'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['class_id'] = this.classId;
    return data;
  }
}