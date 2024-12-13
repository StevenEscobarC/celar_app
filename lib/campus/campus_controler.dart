import 'package:http/http.dart' as http;
import 'dart:convert';

class CampusController {
  final String baseUrl = "http://indeseg.edu.co:8081/webservice/rest/server.php";

  Future<List<dynamic>> fetchData(String token, String function, Map<String, dynamic> params) async {
    try {
      final queryParameters = {
        'wstoken': token,
        'wsfunction': function,
        'moodlewsrestformat': 'json',
        ...params,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response from $function: $data');
        return data;
      } else {
        print('Error ${response.statusCode} in $function: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error in $function: $e');
      return [];
    }
  }

  Future<Map<String,dynamic>> fetchDataObject(String token, String function, Map<String, dynamic> params) async {
    try {
      final queryParameters = {
        'wstoken': token,
        'wsfunction': function,
        'moodlewsrestformat': 'json',
        ...params,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response from $function: $data');
        return data;
      } else {
        print('Error ${response.statusCode} in $function: ${response.reasonPhrase}');
        return {};
      }
    } catch (e) {
      print('Error in $function: $e');
      return {};
    }
  }
}