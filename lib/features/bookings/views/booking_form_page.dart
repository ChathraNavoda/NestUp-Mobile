import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/home/models/listing_model.dart';

class BookingFormPage extends StatefulWidget {
  final Listing listing;
  final ApiClient apiClient;

  const BookingFormPage({
    super.key,
    required this.listing,
    required this.apiClient,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  DateTime? checkIn;
  DateTime? checkOut;
  bool loading = false;
  String error = '';

  Future<void> _pickDate(bool isCheckIn) async {
    final now = DateTime.now();
    final initial = now.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.light,
              surface: AppColors.light,
              onSurface: AppColors.dark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
        } else {
          checkOut = picked;
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (checkIn == null || checkOut == null) {
      setState(() => error = "Please select both dates");
      return;
    }

    setState(() {
      loading = true;
      error = '';
    });

    try {
      final res = await widget.apiClient.post(
        "/bookings",
        data: {
          "listing": widget.listing.id,
          "userName": "John Doe",
          "checkIn": checkIn!.toIso8601String(),
          "checkOut": checkOut!.toIso8601String(),
        },
      );

      if (!mounted) return;
      Navigator.pop(context, true); // pass true back to update state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Booking for ${widget.listing.title} created successfully!",
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      setState(() => error = "Failed to book: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        title: Text(
          "Book ${widget.listing.title}",
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Dates",
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.dark,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      checkIn != null ? fmt.format(checkIn!) : "Check-In",
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.dark,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      checkOut != null ? fmt.format(checkOut!) : "Check-Out",
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            if (error.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                error,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: loading ? null : _submitBooking,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.light,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      "Confirm Booking",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
