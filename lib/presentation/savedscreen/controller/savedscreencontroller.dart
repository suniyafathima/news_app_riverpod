// savedscreencontroller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/sqflite_class/news_db.dart';

// StateNotifier to manage saved news state
class SavedNewsNotifier extends StateNotifier<List<Map>> {
  SavedNewsNotifier() : super([]) {
    loadSavedNews();
  }

  // Fetch saved news
  Future<void> loadSavedNews() async {
    await NewsDb.getSavedNews();
    state = List.from(NewsDb.newsList);
   // state = NewsDb.newsList; // Update the state with saved articles
  }

  // Delete a saved article by its ID
  Future<void> deleteSavedNewsById(String url) async {
    await NewsDb.deleteNewsById(url);
    await loadSavedNews(); // Refresh the news list after deletion
  }
   bool isArticleSaved(String url) {
    return state.any((article) => article['url'] == url);
  }
}

final savedNewsProvider = StateNotifierProvider<SavedNewsNotifier, List<Map>>((ref) {
  return SavedNewsNotifier();
});
