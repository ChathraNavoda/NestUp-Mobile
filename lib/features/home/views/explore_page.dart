import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/home/models/listing_model.dart';
import 'package:nestup/features/home/views/listing_detail_page.dart';

class ExplorePage extends StatefulWidget {
  final ApiClient apiClient;
  const ExplorePage({super.key, required this.apiClient});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Listing> _listings = [];
  List<Listing> _featured = [];
  bool _loading = true;
  String _error = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Villa', 'Apartment', 'House'];

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await widget.apiClient.get('/listings');
      final listings = (response as List)
          .map((json) => Listing.fromJson(json))
          .toList();

      setState(() {
        _listings = listings;
        _featured = listings.take(5).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch listings: $e';
        _loading = false;
      });
    }
  }

  List<Listing> get _filteredListings {
    if (_selectedCategory == 'All') return _listings;
    return _listings.where((l) => l.type == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Text(
                _error,
                style: GoogleFonts.nunito(fontSize: 16, color: AppColors.dark),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchListings,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topPadding + 65),

                    // Featured Carousel
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: _featured.length,
                        itemBuilder: (context, index) {
                          final listing = _featured[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    listing.image,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "\$${listing.price} - ${listing.title}",
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = cat == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                              child: Chip(
                                label: Text(
                                  cat,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.light
                                        : AppColors.dark,
                                  ),
                                ),
                                backgroundColor: isSelected
                                    ? AppColors.primary
                                    : AppColors.accent.withOpacity(0.4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: AppColors.brandPrimary,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Listings Grid
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _filteredListings.length,
                      itemBuilder: (context, index) {
                        final listing = _filteredListings[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListingDetailPage(
                                  listing: listing,
                                  apiClient: widget.apiClient,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    listing.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    listing.title,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.dark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "\$${listing.price}/night",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
