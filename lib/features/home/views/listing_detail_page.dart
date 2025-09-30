import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/bookings/views/booking_form_page.dart';
import 'package:nestup/features/home/models/listing_model.dart';

class ListingDetailPage extends StatefulWidget {
  final Listing listing;
  final ApiClient apiClient;

  const ListingDetailPage({
    super.key,
    required this.listing,
    required this.apiClient,
  });

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  bool _booked = false;

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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
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
            const SizedBox(height: 16),

            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.listing.title,
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.listing.location,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "\$${widget.listing.price}/night",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.listing.description,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.dark.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
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
