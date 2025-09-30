import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/bookings/views/booking_form_page.dart';
import 'package:nestup/features/home/models/listing_model.dart';

class ListingDetailPage extends StatefulWidget {
  final Listing listing;
  final ApiClient apiClient;
  final Set<String> favorites; // current favorites
  final Function(String) onFavoriteToggled; // callback to toggle

  const ListingDetailPage({
    super.key,
    required this.listing,
    required this.apiClient,
    required this.favorites,
    required this.onFavoriteToggled,
  });

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  bool _booked = false;

  bool get _favorited => widget.favorites.contains(widget.listing.id);

  void _toggleFavorite() {
    widget.onFavoriteToggled(widget.listing.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorited ? "Added to favorites" : "Removed from favorites",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            color: AppColors.light,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {}); // refresh icon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          widget.listing.title,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _favorited ? Icons.favorite : Icons.favorite_border,
              color: _favorited ? AppColors.accent : AppColors.light,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.network(
                    widget.listing.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Info section...
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: _booked ? AppColors.light : AppColors.primary,
              foregroundColor: _booked ? AppColors.primary : AppColors.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            child: Text(_booked ? "Booked" : "Book Now"),
            onPressed: _booked
                ? null
                : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingFormPage(
                          listing: widget.listing,
                          apiClient: widget.apiClient,
                        ),
                      ),
                    );

                    if (result == true) {
                      setState(() => _booked = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${widget.listing.title} successfully booked!",
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
                  },
          ),
        ),
      ),
    );
  }
}
