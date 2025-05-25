import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/presentation/discoverscreen/state/discoverscreenstate.dart';


final discoverscreenprovider = StateNotifierProvider((ref) {
  return DiscoverScreenController();
});
class DiscoverScreenController extends StateNotifier<DiscoverScreenState> {
  DiscoverScreenController() : super(DiscoverScreenState());

  Future<void> fetchTopHeadlines() async {
    state = state.copyWith(isLoading: true);
    try {
    
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        topHeadlines: [], 
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
  
}