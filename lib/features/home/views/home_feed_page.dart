import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listings = controller.filteredListings;
    final topPadding = MediaQuery.of(context).padding.top;

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
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        item.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
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

            // Filter Chips
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

            // No results placeholder
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
                            controller.setPriceRange(RangeValues(0, 5000));
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
                    return _buildListingCard(item);
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

  // ---- Filter Chip ----
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    HomeController controller,
  ) {
    final isSelected = controller.activeFilter == label;

    return GestureDetector(
      onTap: () async {
        controller.setFilter(label);

        // --- Price Filter ---
        if (label == "Price") {
          final prices = controller.allListings.map((e) => e.price).toList();
          final minPrice = prices.isNotEmpty
              ? prices.reduce((a, b) => a < b ? a : b).toDouble()
              : 0.0;
          final maxPrice = prices.isNotEmpty
              ? prices.reduce((a, b) => a > b ? a : b).toDouble()
              : 5000.0;

          final range = await showDialog<RangeValues>(
            context: context,
            builder: (context) {
              RangeValues tempRange = controller.priceRange;
              return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  title: const Text("Select Price Range"),
                  content: SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        RangeSlider(
                          values: RangeValues(
                            tempRange.start.clamp(minPrice, maxPrice),
                            tempRange.end.clamp(minPrice, maxPrice),
                          ),
                          min: minPrice,
                          max: maxPrice,
                          divisions: 100,
                          labels: RangeLabels(
                            "\$${tempRange.start.toInt()}",
                            "\$${tempRange.end.toInt()}",
                          ),
                          onChanged: (newRange) {
                            setState(() => tempRange = newRange);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\$${tempRange.start.toInt()}"),
                              Text("\$${tempRange.end.toInt()}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, tempRange),
                      child: const Text("Apply"),
                    ),
                  ],
                ),
              );
            },
          );
          if (range != null) controller.setPriceRange(range);
        }

        // --- Location Filter ---
        if (label == "Location") {
          final locations = controller.allListings
              .map((e) => e.location)
              .toSet()
              .toList();

          final location = await showDialog<String>(
            context: context,
            builder: (context) {
              String? selected = controller.selectedLocation;
              return SimpleDialog(
                title: const Text("Select Location"),
                children: locations.map((loc) {
                  return RadioListTile(
                    value: loc,
                    groupValue: selected,
                    title: Text(loc),
                    onChanged: (value) {
                      selected = value;
                      Navigator.pop(context, value);
                    },
                  );
                }).toList(),
              );
            },
          );
          if (location != null) controller.setLocation(location);
        }

        // --- Type Filter ---
        if (label == "Type") {
          final types = controller.allListings
              .map((e) => e.type)
              .toSet()
              .toList();

          final type = await showDialog<String>(
            context: context,
            builder: (context) {
              String? selected = controller.selectedType;
              return SimpleDialog(
                title: const Text("Select Type"),
                children: types.map((t) {
                  return RadioListTile(
                    value: t,
                    groupValue: selected,
                    title: Text(t),
                    onChanged: (value) {
                      selected = value;
                      Navigator.pop(context, value);
                    },
                  );
                }).toList(),
              );
            },
          );
          if (type != null) controller.setType(type);
        }

        // --- All Filter Reset ---
        if (label == "All") {
          controller.setPriceRange(const RangeValues(0, 5000));
          controller.setLocation(null);
          controller.setType(null);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Material(
          color: Colors.transparent,
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
      ),
    );
  }

  // ---- Listing Card ----
  Widget _buildListingCard(dynamic item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.light,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(item.image, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.location,
                    style: GoogleFonts.nunito(
                      color: AppColors.dark.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${item.price}/night",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
