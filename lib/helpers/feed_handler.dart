import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whispery/globals/strings.dart';
import 'package:whispery/helpers/post.dart';

class FeedHandler {
  static Future<List<Post>> getFeed(response, index) async {
    List<Post> postList;
    final response = await http.get(Strings.feedFunction);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return postList;
      } else {
        postList = PostList.fromJson(json.decode(response.body)).posts;
        return postList;
      }
    } else {
      throw Exception('Error fetching posts.');
    }
  }
}
