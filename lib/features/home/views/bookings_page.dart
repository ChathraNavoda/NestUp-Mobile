import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/auth/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  bool _loading = true;
  String _error = '';
  List<dynamic> _bookings = [];

  Future<void> _fetchBookings(ApiClient apiClient) async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await apiClient.get('/bookings/mine');
      setState(() {
        _bookings = response as List<dynamic>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch bookings: $e';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Delay fetch until we have ApiClient from UserController
    Future.microtask(() {
      final userController = context.read<UserController>();
      _fetchBookings(userController.apiClient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();

    if (!userController.isLoggedIn) {
      return Center(
        child: Text(
          "Please log in to view your bookings.",
          style: GoogleFonts.nunito(fontSize: 16, color: AppColors.dark),
        ),
      );
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Text(
          _error,
          style: GoogleFonts.nunito(fontSize: 16, color: AppColors.dark),
        ),
      );
    }

    if (_bookings.isEmpty) {
      return Center(
        child: Text(
          "No bookings found.",
          style: GoogleFonts.nunito(fontSize: 16, color: AppColors.dark),
        ),
      );
    }

    final topPadding = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
      onRefresh: () => _fetchBookings(userController.apiClient),
      child: ListView.builder(
        padding: EdgeInsets.only(top: topPadding + 56, bottom: 16),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          final listing = booking['listing'];

          final checkIn = DateTime.parse(booking['checkIn']).toLocal();
          final checkOut = DateTime.parse(booking['checkOut']).toLocal();

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
                  listing['image'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                listing['title'] ?? "Unknown",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.dark,
                ),
              ),
              subtitle: Text(
                "Check-in: ${checkIn.toString().split(' ')[0]}\n"
                "Check-out: ${checkOut.toString().split(' ')[0]}",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.dark.withOpacity(0.7),
                ),
              ),
              trailing: Text(
                "\$${listing['price']}",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
