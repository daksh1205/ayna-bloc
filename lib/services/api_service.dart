import 'package:dio/dio.dart';
import 'package:ayna_bloc/models/post.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Post>> fetchPosts() async {
    try {
      final response =
          await _dio.get('http://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        List<Post> posts = (response.data as List).map((post) {
          return Post.fromJson(post);
        }).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
