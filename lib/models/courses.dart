class CourseData {
  final int studentId;
  final int courseId;
  final String courseName;
  final int sedeId;
  final String sedeName;
  final String commercialCompanyName;
  final String state;
  final String stateLabel;
  final String name;
  final String createDate;
  final dynamic dateStart; // Puedes usar DateTime si deseas parsear la fecha
  final dynamic dateEnd;   // Puedes usar DateTime si deseas parsear la fecha
  final dynamic tokenCertificate;
  final bool pdfCertificate;
  final double coste;

  // Constructor de la clase
  CourseData({
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.sedeId,
    required this.sedeName,
    required this.commercialCompanyName,
    required this.state,
    required this.stateLabel,
    required this.name,
    required this.createDate,
    this.dateStart,
    this.dateEnd,
    required this.tokenCertificate,
    required this.pdfCertificate,
    required this.coste,
  });

  // Método de fábrica para crear una instancia desde un Map
  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      studentId: json['student_id'],
      courseId: json['course_id'],
      courseName: json['course_name'],
      sedeId: json['sede_id'],
      sedeName: json['sede_name'],
      commercialCompanyName: json['commercial_company_name'],
      state: json['state'],
      stateLabel: json['state_label'],
      name: json['name'],
      createDate: json['create_date'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      tokenCertificate: json['token_certificate'],
      pdfCertificate: json['pdf_certificate'],
      coste: json['coste'],
    );
  }
}
class UserData {
  final List<CourseData> certificates;

  // Constructor
  UserData({
    required this.certificates,
  });

  // Método de fábrica para crear una instancia a partir de un List
  factory UserData.fromJson(List<dynamic> json) {
    List<CourseData> certificatesList = json
        .map((certificateJson) => CourseData.fromJson(certificateJson))
        .toList();

    return UserData(
      certificates: certificatesList,
    );
  }
}

class ApiResponse {
  final String message;
  final UserData data;

  // Constructor
  ApiResponse({
    required this.message,
    required this.data,
  });

  // Método de fábrica para crear una instancia a partir de un Map
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}
