import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_aplikasi_mobile/models/detail_comic.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import 'package:project_aplikasi_mobile/models/read_chapter.dart';

class ComicApi {
  final String baseUrl = "https://www.sankavollerei.com/comic/bacakomik";

  Future<ComicResponse> getComics(String endpoint, {int page = 1}) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: {'page': page.toString()});

      final response = await http.get(uri);

      if (response.body.isNotEmpty) {
        print(
          'BODY SAMPLE => ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
        );
      }

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody['success'] == true) {
          return ComicResponse.fromJson(jsonBody);
        } else {
          throw Exception('API Success is false');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR => $e');
      rethrow;
    }
  }

  Future<ComicDetail?> getComicDetail(String slug) async {
    try {
      final uri = Uri.parse('$baseUrl/detail/$slug');

      print('REQUEST DETAIL => $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        final data = ComicDetailResponse.fromJson(jsonBody);

        if (data.success) {
          return data.detail;
        } else {
          throw Exception('Gagal memuat detail: Success false');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR GET DETAIL => $e');
      rethrow;
    }
  }

  Future<ReadChapterModel?> getChapterImages(String slug) async {
    try {
      // Endpoint: .../chapter/nano-machine-chapter-1
      final uri = Uri.parse('$baseUrl/chapter/$slug');

      print('FETCH CHAPTER => $uri');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true) {
          return ReadChapterModel.fromJson(jsonBody);
        }
      }
    } catch (e) {
      print('ERROR CHAPTER => $e');
    }
    return null;
  }
}
