import 'dart:convert';

import 'package:flutter_news_app/model/modelAllNews.dart';
import 'package:flutter_news_app/model/modelBbcNews.dart';
import 'package:http/http.dart' as http;

class MyService {
  Future<ModelAllNews> fetchAllNews(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return ModelAllNews.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }

  Future<ModelBbcNews> fetchBBCNews() async {
    String newsUrl =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return ModelBbcNews.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }
}
