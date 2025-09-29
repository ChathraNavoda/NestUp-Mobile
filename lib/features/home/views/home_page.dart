import 'package:flutter/material.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/home/views/home_feed_page.dart';
import 'package:nestup/shared/widgets/floating_bottom_navbar.dart';

import 'bookings_page.dart';
import 'explore_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeFeedPage(),
    ExplorePage(),
    BookingsPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text("John Doe"),
                accountEmail: const Text("john@example.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                decoration: BoxDecoration(color: AppColors.primary),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  // Implement logout
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _pages[_currentIndex],

            // Top-left menu icon
            Positioned(
              top: 16,
              left: 16,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: AppColors.primary, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),

            // Top-right profile icon
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  // Open profile page or drawer section
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),

            // Bottom floating nav bar
            FloatingBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ],
        ),
      ),
    );
  }
}
