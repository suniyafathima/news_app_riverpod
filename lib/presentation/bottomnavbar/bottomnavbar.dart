import 'package:flutter/material.dart';
import 'package:news_app/presentation/discoverscreen/view/discoverscreen.dart';
import 'package:news_app/presentation/news_screen/view/newsscreen.dart';
import 'package:news_app/presentation/profilescreen/view/profilescreen.dart';
import 'package:news_app/presentation/savedscreen/view/savedscreen.dart';

class Bottomnavbar extends StatefulWidget {
  Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    NewsScreen(),
    DiscoverScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 0 ? Icons.home_outlined : Icons.home,
                color: selectedIndex == 0 ? Colors.purple : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 1 ? Icons.explore_outlined : Icons.explore,
                color: selectedIndex == 1 ? Colors.purple : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_border_outlined,
                color: selectedIndex == 2 ? Colors.purple : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 3 ? Colors.purple : Colors.grey,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
