import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/home/models/listing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorites';

  // Save favorites (IDs)
  static Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favorites.toList());
  }

  // Load favorites
  static Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Listing> favoriteListings;
  final Function(String) onFavoriteToggled;

  const FavoritesPage({
    super.key,
    required this.favoriteListings,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteListings.isEmpty) {
      return Center(
        child: Text(
          "No favorites yet",
          style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[700]),
        ),
      );
    }

    final topPadding = MediaQuery.of(context).padding.top;

    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding + 56, bottom: 16),
      itemCount: favoriteListings.length,
      itemBuilder: (context, index) {
        final listing = favoriteListings[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                listing.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              listing.title,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.dark,
              ),
            ),
            subtitle: Text(
              "\$${listing.price}/night",
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.dark.withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => onFavoriteToggled(listing.id),
            ),
          ),
        );
      },
    );
  }
}
