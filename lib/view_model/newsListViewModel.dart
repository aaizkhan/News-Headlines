import 'package:flutter_news_app/model/modelAllNews.dart';
import 'package:flutter_news_app/model/modelBbcNews.dart';
import 'package:flutter_news_app/services/services.dart';

class NewsListViewModel {
  Future<ModelAllNews> fetchNews(String category) async {
    final myApiResult = await MyService().fetchAllNews(category);

    return myApiResult;
  }

  Future<ModelBbcNews> fetchBBcNews() async {
    final bbcApi = await MyService().fetchBBCNews();

    return bbcApi;
  }
}
