// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nestup/core/theme/app_colors.dart';
// import 'package:provider/provider.dart';

// import '../controllers/home_controller.dart';

// class HomeFeedPage extends StatelessWidget {
//   const HomeFeedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<HomeController>(context);

//     if (controller.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     // Just use status bar height to avoid overlap
//     final topPadding = MediaQuery.of(context).padding.top;

//     return RefreshIndicator(
//       onRefresh: () => controller.fetchListings(),
//       child: CustomScrollView(
//         slivers: [
//           // Push content down so it doesn't overlap top menu/profile icons
//           SliverToBoxAdapter(child: SizedBox(height: topPadding + 65)),

//           // Carousel
//           SliverToBoxAdapter(
//             child: CarouselSlider.builder(
//               itemCount: controller.listings.length > 5
//                   ? 5
//                   : controller.listings.length,
//               itemBuilder: (context, index, realIndex) {
//                 final item = controller.listings[index];
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.network(
//                     item.image,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 );
//               },
//               options: CarouselOptions(
//                 height: 200,
//                 enlargeCenterPage: true,
//                 autoPlay: true,
//                 viewportFraction: 0.85,
//                 autoPlayInterval: const Duration(seconds: 3),
//               ),
//             ),
//           ),

//           const SliverToBoxAdapter(child: SizedBox(height: 12)),

//           // Filter Chips
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 40,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 children: [
//                   _buildFilterChip('Price'),
//                   _buildFilterChip('Location'),
//                   _buildFilterChip('Type'),
//                   _buildFilterChip('More'),
//                 ],
//               ),
//             ),
//           ),

//           const SliverToBoxAdapter(child: SizedBox(height: 12)),

//           // Grid
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 final item = controller.listings[index];
//                 return _buildListingCard(item);
//               }, childCount: controller.listings.length),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 0.75,
//               ),
//             ),
//           ),

//           const SliverToBoxAdapter(child: SizedBox(height: 16)),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       child: Chip(
//         label: Text(
//           label,
//           style: GoogleFonts.nunito(
//             fontWeight: FontWeight.w600,
//             color: AppColors.dark,
//           ),
//         ),
//         backgroundColor: AppColors.accent.withOpacity(0.4),
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         shape: RoundedRectangleBorder(
//           side: BorderSide(color: AppColors.brandPrimary, width: 1.2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   Widget _buildListingCard(dynamic item) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   Image.network(
//                     item.image,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.white70,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.favorite_border, size: 18),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.title,
//                     style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.location,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "\$${item.price}/night",
//                     style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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

    // Status bar height
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchListings(),
        child: CustomScrollView(
          slivers: [
            // Push content down so it doesn't overlap menu/profile icons
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
                    _buildFilterChip('All', controller),
                    _buildFilterChip('Price', controller),
                    _buildFilterChip('Location', controller),
                    _buildFilterChip('Type', controller),
                    _buildFilterChip('More', controller),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Grid of Listings
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
  Widget _buildFilterChip(String label, HomeController controller) {
    final isSelected = controller.activeFilter == label;

    return GestureDetector(
      onTap: () => controller.setFilter(label == "All" ? null : label),
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
          mainAxisSize: MainAxisSize.min, // avoids overflow
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
                      color: AppColors.secondary,
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
