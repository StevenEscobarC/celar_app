class Certificate {
  final int id;
  final String state;
  final String name;
  final String course;
  final DateTime createDate;
  final bool dateStart;
  final bool dateEnd;
  final bool tokenCertificate;
  final bool pdfCertificate;

  // Constructor
  Certificate({
    required this.id,
    required this.state,
    required this.name,
    required this.course,
    required this.createDate,
    required this.dateStart,
    required this.dateEnd,
    required this.tokenCertificate,
    required this.pdfCertificate,
  });

  // Método de fábrica para crear una instancia a partir de un Map
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      state: json['state'],
      name: json['name'],
      course: json['course'],
      createDate: DateTime.parse(json['create_date']),
      dateStart: json['date_start'].toString().toLowerCase() == 'true',
      dateEnd: json['date_end'].toString().toLowerCase() == 'true',
      tokenCertificate: json['token_certificate'],
      pdfCertificate: json['pdf_certificate'],
    );
  }
}

class UserData {
  final String name;
  final List<Certificate> certificates;

  // Constructor
  UserData({
    required this.name,
    required this.certificates,
  });

  // Método de fábrica para crear una instancia a partir de un Map
  factory UserData.fromJson(Map<String, dynamic> json) {
    var certificatesJson = json['certificates'] as List;
    List<Certificate> certificatesList = certificatesJson
        .map((certificateJson) => Certificate.fromJson(certificateJson))
        .toList();

    return UserData(
      name: json['name'],
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
