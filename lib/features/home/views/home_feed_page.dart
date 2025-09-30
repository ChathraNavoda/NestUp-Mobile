import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

class HomeFeedPage extends StatefulWidget {
  final Set<String> favorites;
  final Function(String) onFavoriteToggled;

  const HomeFeedPage({
    super.key,
    required this.favorites,
    required this.onFavoriteToggled,
  });

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listings = controller.filteredListings;
    final topPadding = MediaQuery.of(context).padding.top;

    void _toggleFavorite(String id) {
      setState(() {
        widget.onFavoriteToggled(id); // update parent favorites
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.favorites.contains(id)
                ? 'Added from favorites'
                : 'Removed to favorites',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              color: AppColors.light,
            ),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchListings(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: topPadding + 65)),

            // Carousel
            if (listings.isNotEmpty)
              SliverToBoxAdapter(
                child: CarouselSlider.builder(
                  itemCount: listings.length > 5 ? 5 : listings.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = listings[index];
                    final isFav = widget.favorites.contains(item.id);

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.accent : AppColors.light,
                              size: 28,
                            ),
                            onPressed: () => _toggleFavorite(item.id),
                          ),
                        ),
                      ],
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 0.85,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Filter Chips (same as before)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(context, 'All', controller),
                    _buildFilterChip(context, 'Price', controller),
                    _buildFilterChip(context, 'Location', controller),
                    _buildFilterChip(context, 'Type', controller),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // No results
            if (listings.isEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No listings match your filter.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            controller.setPriceRange(
                              const RangeValues(0, 5000),
                            );
                            controller.setLocation(null);
                            controller.setType(null);
                          },
                          child: const Text("Reset Filters"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Grid of Listings
            if (listings.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = listings[index];
                    final isFav = widget.favorites.contains(item.id);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(item.image, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav
                                    ? AppColors.accent
                                    : AppColors.light,
                              ),
                              onPressed: () => _toggleFavorite(item.id),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black45,
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.title,
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "\$${item.price}/night",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: listings.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    HomeController controller,
  ) {
    final isSelected = controller.activeFilter == label;

    return GestureDetector(
      onTap: () => controller.setFilter(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(
            label,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.light : AppColors.dark,
            ),
          ),
          backgroundColor: isSelected
              ? AppColors.primary
              : AppColors.accent.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.brandPrimary, width: 1.2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
