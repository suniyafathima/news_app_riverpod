
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/sqflite_class/news_db.dart';

class SavedNewsNotifier extends StateNotifier<List<Map>> {
  SavedNewsNotifier() : super([]) {
    loadSavedNews();
  }
  Future<void> loadSavedNews() async {
    await NewsDb.getSavedNews();
    state = List.from(NewsDb.newsList);
   // state = NewsDb.newsList; 
  }

  Future<void> deleteSavedNewsById(String url) async {
    await NewsDb.deleteNewsById(url);
    await loadSavedNews(); 
  }
   bool isArticleSaved(String url) {
    return state.any((article) => article['url'] == url);
  }
}

final savedNewsProvider = StateNotifierProvider<SavedNewsNotifier, List<Map>>((ref) {
  return SavedNewsNotifier();
});
