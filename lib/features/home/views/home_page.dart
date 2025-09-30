import 'package:flutter/material.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/auth/controllers/user_controller.dart';
import 'package:nestup/features/home/views/home_feed_page.dart';
import 'package:nestup/shared/widgets/floating_bottom_navbar.dart';
import 'package:provider/provider.dart';

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

  late List<Widget> _pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final apiClient = Provider.of<UserController>(
      context,
      listen: false,
    ).apiClient;

    _pages = [
      const HomeFeedPage(),
      ExplorePage(apiClient: apiClient),
      const BookingsPage(),
      const FavoritesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        final user = userController.user;

        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(user?.name ?? "Guest"),
                    accountEmail: Text(user?.email ?? ""),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: (user?.avatar?.isNotEmpty ?? false)
                          ? ClipOval(
                              child: Image.network(
                                user!.avatar!,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            )
                          : const Icon(Icons.person, color: Colors.white),
                    ),
                    decoration: BoxDecoration(color: AppColors.primary),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profile"),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(userController.isLoggedIn ? "Logout" : "Login"),
                    onTap: () {
                      Navigator.pop(context);
                      if (userController.isLoggedIn) {
                        userController.logout();
                      } else {
                        // Navigate to login page
                      }
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
                Positioned(
                  top: 16,
                  left: 16,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: (user?.avatar?.isNotEmpty ?? false)
                        ? ClipOval(
                            child: Image.network(
                              user!.avatar!,
                              fit: BoxFit.cover,
                              width: 28,
                              height: 28,
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                ),

                // Show login button only when logged out
                if (!userController.isLoggedIn)
                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.primary,
                      child: InkWell(
                        onTap: () async {
                          print('[TEST] Login button pressed');
                          try {
                            // await userController.login(
                            //   'tom@riddle.com',
                            //   'TomR123!',
                            // );
                            await userController.login(
                              'john@example.com',
                              'Password123!',
                            );

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Welcome back!'),
                                  backgroundColor: AppColors.brandPrimary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            print('[TEST] Login failed: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login failed: $e'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.login_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Quick Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                FloatingBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
