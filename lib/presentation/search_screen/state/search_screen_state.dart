import 'package:news_app/repository/api/news_screen/news_res_model.dart';

class SearchScreenState {
  final bool isLoading;
  final List<Article> searchResults;

  SearchScreenState({
    this.isLoading = false,
    this.searchResults = const [],
  });

  SearchScreenState copyWith({
    bool? isLoading,
    List<Article>? searchResults,
  }) {
    return SearchScreenState(
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
