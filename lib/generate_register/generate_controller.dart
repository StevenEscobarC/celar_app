import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:celar_app/models/generate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateController {
  late SharedPreferences prefs;
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Content-Length': '',
    'Host': 'indeseg.edu.co',
  };

  // Future<List<Certificate>> list() async {
  //   prefs = await SharedPreferences.getInstance();
  //   final body = {
  //     // 'token': prefs.getString('token'),
  //     // 'ref_student': prefs.getString('cedula'),
  //     'token':
  //         "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGV",
  //     'ref_student': "1143926528",
  //   };
  //   late ApiResponse model;
  //   await http
  //       .post(Uri.parse('https://indeseg.edu.co/app/v1/courses'),
  //           headers: headers, body: body)
  //       .then((response) {
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       model = ApiResponse.fromJson(data);
  //     } else {
  //       throw Exception('Error al cargar los certificados');
  //     }
  //   });
  //   return model.data.certificates;
  // }

  Future<List<Certificate>> list() async {
    late ApiResponse model;
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=a203ff3b17eba40541345a332a9a07485f62f281'
    };
    var request = http.Request(
        'POST', Uri.parse('https://indeseg.edu.co/app/v1/courses'));
    request.body = json.encode({
      "token":
          "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGV",
      "ref_student": "1143926528"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
        final data = json.decode(await response.stream.bytesToString());
        model = ApiResponse.fromJson(data);
    } else {
      print(response.reasonPhrase);
    }
    return model.data.certificates;
  }
}
