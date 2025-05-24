import 'package:news_app/repository/api/news_screen/news_res_model.dart';

class DiscoverScreenState {
  final bool? isLoading;
  final List<Article>? topHeadlines; // for carousel


  DiscoverScreenState({
    this.isLoading,
    this.topHeadlines,

  });

  DiscoverScreenState copyWith({
    bool? isLoading,
    List<Article>? topHeadlines,

  }) {
    return DiscoverScreenState(
      isLoading: isLoading ?? this.isLoading,
      topHeadlines: topHeadlines ?? this.topHeadlines,

    );
  }
}
