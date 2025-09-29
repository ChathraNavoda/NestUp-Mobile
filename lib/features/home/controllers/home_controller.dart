import 'package:flutter/material.dart';
import 'package:nestup/features/home/models/listing_model.dart';
import 'package:nestup/features/listings/services/listing_service.dart';

class HomeController extends ChangeNotifier {
  final ListingService listingService;

  HomeController({required this.listingService});

  List<Listing> listings = [];
  bool isLoading = false;

  Future<void> fetchListings() async {
    isLoading = true;
    notifyListeners();

    try {
      listings = await listingService.getListings();
    } catch (e) {
      print("Error fetching listings: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
