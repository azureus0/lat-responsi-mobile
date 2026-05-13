import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static String _endpointFor(String type) {
    switch (type) {
      case 'news':
        return 'articles';
      case 'blog':
        return 'blogs';
      case 'report':
        return 'reports';
      default:
        return 'articles';
    }
  }

  static Future<List<Article>> fetchList(String type, {int limit = 10}) async {
    final endpoint = _endpointFor(type);
    final uri = Uri.parse('$_baseUrl/$endpoint/?limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data $type');
    }
  }

  static Future<Article> fetchDetail(String type, int id) async {
    final endpoint = _endpointFor(type);
    final uri = Uri.parse('$_baseUrl/$endpoint/$id/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail');
    }
  }
}
