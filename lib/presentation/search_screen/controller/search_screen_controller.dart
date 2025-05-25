import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/services/news_api_service.dart';

import 'package:news_app/presentation/search_screen/state/search_screen_state.dart';

final searchScreenProvider = StateNotifierProvider<SearchScreenController, SearchScreenState>((ref) {
  return SearchScreenController();
});

class SearchScreenController extends StateNotifier<SearchScreenState> {
  final NewsApiService newsApiService = NewsApiService();

  SearchScreenController() : super(SearchScreenState());

  Future<void> fetchSearchResults(String query) async {
    state = state.copyWith(isLoading: true);

    try {
      final resModel = await NewsApiService().searchNews(query);

      if (resModel != null && resModel.articles!.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          searchResults: resModel.articles,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          searchResults: [],
  
        );
      }
    } catch (e) {
      log("Error: $e");
      state = state.copyWith(
        isLoading: false,
    
      );
    }
  }
}
