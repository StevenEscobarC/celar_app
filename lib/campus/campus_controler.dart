import 'package:http/http.dart' as http;
import 'dart:convert';

/// Controlador para manejar las peticiones al servidor del campus.
class CampusController {
  /// URL base para las peticiones al servidor.
  final String baseUrl = "http://indeseg.edu.co:8081/webservice/rest/server.php";

  /// Método para obtener datos del servidor en forma de lista.
  ///
  /// [token] es el token de autenticación.
  /// [function] es la función del servidor a la que se llama.
  /// [params] son los parámetros adicionales para la petición.
  ///
  /// Retorna una lista de datos en formato JSON.
  Future<List<dynamic>> fetchData(String token, String function, Map<String, dynamic> params) async {
    try {
      // Parámetros de la consulta.
      final queryParameters = {
        'wstoken': token,
        'wsfunction': function,
        'moodlewsrestformat': 'json',
        ...params,
      };

      // Construcción de la URI con los parámetros de consulta.
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      // Realización de la petición GET.
      final response = await http.get(uri);

      // Verificación del estado de la respuesta.
      if (response.statusCode == 200) {
        // Decodificación de la respuesta en formato JSON.
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

  /// Método para obtener datos del servidor en forma de objeto.
  ///
  /// [token] es el token de autenticación.
  /// [function] es la función del servidor a la que se llama.
  /// [params] son los parámetros adicionales para la petición.
  ///
  /// Retorna un mapa de datos en formato JSON.
  Future<Map<String, dynamic>> fetchDataObject(String token, String function, Map<String, dynamic> params) async {
    try {
      // Parámetros de la consulta.
      final queryParameters = {
        'wstoken': token,
        'wsfunction': function,
        'moodlewsrestformat': 'json',
        ...params,
      };

      // Construcción de la URI con los parámetros de consulta.
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      // Realización de la petición GET.
      final response = await http.get(uri);

      // Verificación del estado de la respuesta.
      if (response.statusCode == 200) {
        // Decodificación de la respuesta en formato JSON.
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