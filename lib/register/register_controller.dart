
import 'package:http/http.dart' as http;

class RegisterController {
  Future<void> register(body) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    await http
        .post(Uri.parse('http://127.0.0.1:5000/register'), headers: headers, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception('Error al cargar los certificados');
      }
    });
  }
} 