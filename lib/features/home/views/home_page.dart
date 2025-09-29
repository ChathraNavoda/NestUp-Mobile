import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';

import 'bookings_page.dart';
import 'explore_page.dart';
import 'favorites_page.dart';
import 'home_feed_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeFeedPage(), // 🏠 Main feed / recommendations
    ExplorePage(), // 🔍 Explore
    BookingsPage(), // 📅 Bookings
    FavoritesPage(), // ❤️ Favorites
    ProfilePage(), // 👤 Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomFloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          NavItem(icon: Icons.home, label: "Home"),
          NavItem(icon: Icons.search, label: "Explore"),
          NavItem(icon: Icons.calendar_today, label: "Bookings"),
          NavItem(icon: Icons.favorite, label: "Favorites"),
          NavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}

// Dummy floating nav placeholder
class CustomFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const CustomFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : Colors.white70,
                ),
                Text(
                  item.label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}
