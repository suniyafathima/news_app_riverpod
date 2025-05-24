import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/services/news_api_service.dart';
import 'package:news_app/presentation/news_screen/state/news_state.dart';

final newsScreenProvider = StateNotifierProvider((ref) {
  return NewsScreenController();
});

class NewsScreenController extends StateNotifier<NewsState> {
  final NewsApiService apiService = NewsApiService();

  NewsScreenController() : super(NewsState());

  Future<void> fetchTopHeadlines() async {
    state = state.copyWith(isLoading: true);
    final result = await apiService.fetchTopHeadlines();

    if (result != null) {
      state = state.copyWith(
        isLoading: false,
        topHeadlines: result.articles,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchNewsByCategory({
    required String category,
    required int index,
  }) async {
    state = state.copyWith(
      isLoading: true,
      selectedCategoryIndex: index,
    );

    final result = await apiService.fetchNewsByCategory(category);

    if (result != null) {
      state = state.copyWith(
        categoryArticles: result.articles,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}
