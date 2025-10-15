import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import '../../widgets/glass_bottom_nav.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Only render the current page to avoid Google Maps initialization crash
          _pages[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
