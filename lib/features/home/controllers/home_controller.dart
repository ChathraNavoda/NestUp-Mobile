import 'package:flutter/material.dart';
import 'package:nestup/features/home/models/listing_model.dart';
import 'package:nestup/features/listings/services/listing_service.dart';

class HomeController extends ChangeNotifier {
  // All listings fetched from API
  List<Listing> allListings = [];

  // Listings after applying filters
  List<Listing> filteredListings = [];

  // Active filter type (Price, Location, Type, etc.)
  String? activeFilter;

  // Filter inputs
  RangeValues priceRange = const RangeValues(0, 1000);
  String? selectedLocation;
  String? selectedType;

  // Loading state
  bool isLoading = true;

  // ListingService instance
  final ListingService listingService;

  // Constructor: requires ListingService
  HomeController({required this.listingService}) {
    fetchListings();
  }

  // Fetch listings from API
  Future<void> fetchListings() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch data from API via ListingService
      allListings = await listingService.getListings();

      // Initially, show all listings
      filteredListings = List.from(allListings);
    } catch (e) {
      print("Error fetching listings: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Set active filter (Price, Location, Type, etc.)
  void setFilter(String? filter) {
    activeFilter = filter;
    applyFilters();
  }

  // Set price range filter
  void setPriceRange(RangeValues range) {
    priceRange = range;
    applyFilters();
  }

  // Set location filter
  void setLocation(String? location) {
    selectedLocation = location;
    applyFilters();
  }

  // Set type filter
  void setType(String? type) {
    selectedType = type;
    applyFilters();
  }

  // Apply all filters to the listings
  void applyFilters() {
    filteredListings = allListings.where((listing) {
      bool matches = true;

      // Price filter
      matches =
          matches &&
          (listing.price >= priceRange.start &&
              listing.price <= priceRange.end);

      // Location filter
      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        matches = matches && (listing.location == selectedLocation);
      }

      // Type filter
      if (selectedType != null && selectedType!.isNotEmpty) {
        matches = matches && (listing.type == selectedType);
      }

      return matches;
    }).toList();

    notifyListeners();
  }
}
