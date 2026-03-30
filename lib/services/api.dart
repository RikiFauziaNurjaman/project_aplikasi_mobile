import 'dart:convert';
import 'package:http/http.dart' as http;


class DogApiService {
  static Future<DogModel> fetchRandomDog() async {
    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breeds/image/random'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DogModel.fromJson(data);
    } else {
      throw Exception('Gagal ambil data');
    }
  }
}