import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment_task/src/models/picsum_image.dart';

class PicsumRepository {
  Future<List<PicsumImage>> fetchImages({int limit = 10}) async {
    final url = Uri.parse('https://picsum.photos/v2/list?limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PicsumImage.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
