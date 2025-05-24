import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/presentation/news_details/view/news_details.dart';
import 'package:news_app/presentation/news_screen/controller/news_screen_controller.dart';
import 'package:news_app/presentation/savedscreen/controller/savedscreencontroller.dart';
import 'package:news_app/presentation/search_screen/view/search_screen.dart';

import 'package:news_app/repository/api/news_screen/news_res_model.dart';
import 'package:news_app/sqflite_class/news_db.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  Set<String> savedTitles = {}; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
     await ref.read(newsScreenProvider.notifier).fetchTopHeadlines();
     await ref.read(newsScreenProvider.notifier).fetchNewsByCategory(category: "All", index: 0);

    });
  }

  List<String> categories = ["All", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
     final screenstate = ref.watch(newsScreenProvider);
    final selectedCategoryIndex = screenstate.selectedCategoryIndex;
      
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News Time",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Top Headlines",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // Carousel
                CarouselSlider(
                  items: List.generate(
                   screenstate.topHeadlines!.length > 5 ? 5 : screenstate.topHeadlines!.length,
                   (index) => buildCarousal(screenstate.topHeadlines![index]),
                 ),
                options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true 
                ),
                 ),
        
                  SizedBox(height: 10),
        
                  // Category Tabs
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () async {
                             final selectedCategory = categories[index];
                             await ref.read(newsScreenProvider.notifier)
                              .fetchNewsByCategory(category: selectedCategory, index: index);
                           },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.purple : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        
                  SizedBox(height: 10),
        
                  // List of News
                  screenstate.isLoading! || screenstate.categoryArticles == null
                   ? Center(child: CircularProgressIndicator())
                   :ListView.builder(
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemCount:  screenstate.categoryArticles!.length,
                     itemBuilder: (context, index) {
                         
                       final article = screenstate.categoryArticles![index];
                       savedTitles.contains(article.title);
                       return InkWell(
                         onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetails(article: article,)));
                         },
                         child: Card(
                           margin:
                               EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                           child: Padding(
                             padding: EdgeInsets.all(12),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 // Image
                                 ClipRRect(
                                   child: CachedNetworkImage(
                                    imageUrl: screenstate.categoryArticles![index].urlToImage ?? "",
                                     width: 100,
                                     height: 100,
                                     fit: BoxFit.cover,
                                     // placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.broken_image),
                                   ),
                                 ),
                                 SizedBox(width: 12),
                             
                                 // Text content
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                          screenstate.categoryArticles![index].title ?? "",
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 16),
                                       ),
                                       SizedBox(height: 5),
                                       Text(
                                          screenstate.categoryArticles![index].description ?? "",
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(fontSize: 14),
                                       ),
                                     ],
                                   ),
                                 ),
                                 SizedBox(width: 12),
                           IconButton(
                           onPressed: () async {
                          if (article.url != null) {
                          final savedArticles = ref.read(savedNewsProvider);
                 if (savedArticles.any((savedArticle) => savedArticle['url'] == article.url)) {
        // If the article is already saved, remove it
        if (article.url != null) {
          await NewsDb.deleteNewsById(article.url!);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed from saved articles")));
      } else {
        // If the article is not saved, save it
        await NewsDb.saveNews(
          author: article.author,
          title: article.title,
          description: article.description,
          urlToImage: article.urlToImage,
          publishedAt: article.publishedAt.toString(),
          content: article.content,
          url: article.url,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Article saved")));
      }

      // Refresh the saved news list
      await ref.read(savedNewsProvider.notifier).loadSavedNews();
    }
  },
  icon: Icon(
    // Check if the article is saved by checking against the saved articles in the provider
    ref.watch(savedNewsProvider).any((savedArticle) => savedArticle['url'] == article.url)
        ? Icons.bookmark
        : Icons.bookmark_add_outlined,
    size: 25,
  ),
)

],
 ),
     ),
),
      );
      },
       ),
        ],
       ),
      ),
    );
  }

  Widget buildCarousal(Article article) {
    return InkWell(
     onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetails(
            article: article
          ),
        ),
      );},
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(

        image: DecorationImage(
          image: CachedNetworkImageProvider(
            article.urlToImage ?? "",
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              article.source?.name ?? "",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Text(
            article.title ?? "",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Text(
            article.description ?? "",
            style: TextStyle(color: Colors.white, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
}
