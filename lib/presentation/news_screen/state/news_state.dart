import 'package:news_app/repository/api/news_screen/news_res_model.dart';

class NewsState {
  final bool? isLoading;
  final List<Article>? topHeadlines; 
  final List<Article>? categoryArticles;
   final int selectedCategoryIndex;

  NewsState({
    this.isLoading,
    this.topHeadlines = const [],
    this.categoryArticles = const [],
     this.selectedCategoryIndex = 0,
  });

  NewsState copyWith({
    bool? isLoading,
    List<Article>? topHeadlines,
    List<Article>? categoryArticles,
    int? selectedCategoryIndex,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      topHeadlines: topHeadlines ?? this.topHeadlines,
      categoryArticles: categoryArticles ?? this.categoryArticles,
        selectedCategoryIndex:selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}
