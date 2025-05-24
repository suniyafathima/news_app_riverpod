import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/repository/api/news_screen/news_res_model.dart';

class NewsApiService {
  Future<NewsResModel?> fetchTopHeadlines() async {
    final response = await ApiHelper.getData(
      endpoint: "/v2/top-headlines?country=us&apiKey=${AppConfig.apiKey}",
    );

    if (response != null) {
      try {
        return newsResModelFromJson(response);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<NewsResModel?> fetchNewsByCategory(String category) async {
    final String endpoint = category.toLowerCase() == "all"
        ? "/v2/everything?q=keyword&apiKey=${AppConfig.apiKey}"
        : "/v2/top-headlines?country=us&category=${category.toLowerCase()}&apiKey=${AppConfig.apiKey}";

    final response = await ApiHelper.getData(endpoint: endpoint);
    if (response != null) {
      try {
        return newsResModelFromJson(response);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
