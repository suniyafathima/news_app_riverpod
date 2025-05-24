import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/presentation/news_details/view/news_details.dart';

import 'package:news_app/presentation/search_screen/controller/search_screen_controller.dart';
import 'package:news_app/repository/api/news_screen/news_res_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  void onSearch(String query) {
    if (query.trim().isNotEmpty) {
      ref.read(searchScreenProvider.notifier).fetchSearchResults(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchScreenProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: searchController,
          onSubmitted: onSearch,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
              },
            ),
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : state.searchResults.isEmpty
              ? Center(child: Text("No results found"))
              : ListView.builder(
                  itemCount: state.searchResults.length,
                  itemBuilder: (context, index) {
                    final Article article = state.searchResults[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetails(article: article),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: article.urlToImage != null
                            ? Image.network(
                                article.urlToImage!,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                color: Colors.grey[300],
                                child: Icon(Icons.image),
                              ),
                        title: Text(
                          article.title ?? "No Title",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          article.description ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
