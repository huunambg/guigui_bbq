class GradeWithStudent {
  int? gradeId;
  int? studentId;
  int? subjectId;
  int? classId;
  double? ddgtx1;
  double? ddgtx2;
  double? ddgtx3;
  double? ddgtx4;
  double? ddgGk;
  double? ddgCk;
  double? dtbMhk;
  String? academicYear;
  String? semester;
  String? fullName;
  String? dateOfBirth;

  GradeWithStudent(
      {this.gradeId,
      this.studentId,
      this.subjectId,
      this.classId,
      this.ddgtx1,
      this.ddgtx2,
      this.ddgtx3,
      this.ddgtx4,
      this.ddgGk,
      this.ddgCk,
      this.dtbMhk,
      this.academicYear,
      this.semester,
      this.fullName,
      this.dateOfBirth});

  GradeWithStudent.fromJson(Map<String, dynamic> json) {
    gradeId = json['grade_id'];
    studentId = json['student_id'];
    subjectId = json['subject_id'];
    classId = json['class_id'];
    ddgtx1 = (json['ddgtx1'] as num).toDouble();
    ddgtx2 = (json['ddgtx2'] as num).toDouble();
    ddgtx3 = (json['ddgtx3'] as num).toDouble();
    ddgtx4 = (json['ddgtx4'] as num).toDouble();
    ddgGk = (json['ddg_gk'] as num).toDouble();
    ddgCk = (json['ddg_ck'] as num).toDouble();
    dtbMhk = (json['dtb_mhk'] as num).toDouble();;
    academicYear = json['academic_year'];
    semester = json['semester'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grade_id'] = this.gradeId;
    data['student_id'] = this.studentId;
    data['subject_id'] = this.subjectId;
    data['class_id'] = this.classId;
    data['ddgtx1'] = this.ddgtx1;
    data['ddgtx2'] = this.ddgtx2;
    data['ddgtx3'] = this.ddgtx3;
    data['ddgtx4'] = this.ddgtx4;
    data['ddg_gk'] = this.ddgGk;
    data['ddg_ck'] = this.ddgCk;
    data['dtb_mhk'] = this.dtbMhk;
    data['academic_year'] = this.academicYear;
    data['semester'] = this.semester;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    return data;
  }
}