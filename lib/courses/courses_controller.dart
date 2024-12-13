import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:celar_app/models/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesController {
  late SharedPreferences prefs;

  Future<List<CourseData>> list() async {
    late ApiResponse model;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=a203ff3b17eba40541345a332a9a07485f62f281'
    };
    var request = http.Request(
        'POST', Uri.parse('https://indeseg.edu.co/app/v1/courses'));
    request.body = json.encode({
      "token":
          "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGV",
      "ref_student": prefs.getString('cedula')
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      model = ApiResponse.fromJson(data);
    } else {
      print(response.reasonPhrase);
    }
    return model.data.certificates;
  }

  Future<List<CourseData>> preregister(courseId) async {
    prefs = await SharedPreferences.getInstance();
    final body = {
      'token': prefs.getString('token'),
      'cedula': prefs.getString('cedula'),
      'course_id': courseId,
    };
    var data;
    await http
        .post(Uri.parse('https://indeseg.edu.co/v1/preregister'), body: body)
        .then((response) {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      } else {
        throw Exception('Error al cargar los certificados');
      }
    });
    return data;
  }
}
