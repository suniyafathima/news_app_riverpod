import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/presentation/search_screen/state/search_screen_state.dart';
import 'package:news_app/repository/api/news_screen/news_res_model.dart';

final searchScreenProvider = StateNotifierProvider((ref) {
  return SearchScreenController();
});

class SearchScreenController extends StateNotifier<SearchScreenState> {
  SearchScreenController() : super(SearchScreenState());

  Future<void> fetchSearchResults(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=3aeeb62a8c5b4471af0f71e9e8f1b21b'));

      if (response.statusCode == 200) {
        final resModel = newsResModelFromJson(response.body);
        state = state.copyWith(
          isLoading: false,
          searchResults: resModel.articles,
        );
      } else {
        log("Failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
