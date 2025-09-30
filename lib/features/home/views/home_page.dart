import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/auth/controllers/user_controller.dart';
import 'package:nestup/features/home/models/listing_model.dart';
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

  final Set<String> _favorites = {};
  List<Listing> _favoriteListings = [];

  List<Widget>? _pages; // nullable, safe until initialized
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initFavorites();
  }

  Future<void> _initFavorites() async {
    final savedFavorites = await FavoritesService.loadFavorites();
    _favorites.addAll(savedFavorites);
    await _fetchFavoriteListings();

    if (!mounted) return;

    _updatePages();
    setState(() {
      _loading = false; // pages are ready
    });
  }

  Future<void> _fetchFavoriteListings() async {
    if (_favorites.isEmpty) {
      _favoriteListings = [];
      return;
    }

    final apiClient = Provider.of<UserController>(
      context,
      listen: false,
    ).apiClient;
    final response = await apiClient.get('/listings');
    final allListings = (response as List)
        .map((json) => Listing.fromJson(json))
        .toList();

    _favoriteListings = allListings
        .where((l) => _favorites.contains(l.id))
        .toList();
  }

  void _toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
      _favoriteListings.removeWhere((l) => l.id == id);
    } else {
      _favorites.add(id);
      await _fetchFavoriteListings();
    }

    await FavoritesService.saveFavorites(_favorites);

    if (!mounted) return;
    _updatePages();
    setState(() {});
  }

  void _updatePages() {
    final apiClient = Provider.of<UserController>(
      context,
      listen: false,
    ).apiClient;

    _pages = [
      HomeFeedPage(favorites: _favorites, onFavoriteToggled: _toggleFavorite),
      ExplorePage(
        favorites: _favorites,
        onFavoriteToggled: _toggleFavorite,
        apiClient: apiClient,
      ),
      const BookingsPage(),
      FavoritesPage(
        favoriteListings: _favoriteListings,
        onFavoriteToggled: _toggleFavorite,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _pages == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userController = Provider.of<UserController>(context);
    final user = userController.user;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  user?.name ?? "Guest",
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                ),
                accountEmail: Text(
                  user?.email ?? "",
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w500),
                ),
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
                title: Text("Profile", style: GoogleFonts.nunito()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text("Settings", style: GoogleFonts.nunito()),
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  userController.isLoggedIn ? "Logout" : "Login",
                  style: GoogleFonts.nunito(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (userController.isLoggedIn) userController.logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _pages![_currentIndex],
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
                      try {
                        await userController.login(
                          'john@example.com',
                          'Password123!',
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Welcome back!',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.light,
                                ),
                              ),
                              backgroundColor: AppColors.brandPrimary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Login failed: $e',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.light,
                                ),
                              ),
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
  }
}
