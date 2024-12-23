class Class {
  int? classId;
  String? className;
  String? academicYear;
  int? homeroomTeacherId;

  Class(
      {this.classId,
      this.className,
      this.academicYear,
      this.homeroomTeacherId});

  Class.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    className = json['class_name'];
    academicYear = json['academic_year'];
    homeroomTeacherId = json['homeroom_teacher_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    data['academic_year'] = this.academicYear;
    data['homeroom_teacher_id'] = this.homeroomTeacherId;
    return data;
  }
}