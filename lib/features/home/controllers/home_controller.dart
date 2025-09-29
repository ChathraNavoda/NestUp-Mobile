import 'package:flutter/material.dart';
import 'package:nestup/features/home/models/listing_model.dart';

import '../../listings/services/listing_service.dart';

class HomeController extends ChangeNotifier {
  final ListingService listingService;

  HomeController({required this.listingService});

  List<Listing> _listings = [];
  List<Listing> get listings => _listings;

  String? _activeFilter;
  String? get activeFilter => _activeFilter;

  bool isLoading = false;

  List<Listing> get filteredListings {
    if (_activeFilter == null) return _listings;
    if (_activeFilter == 'Price') {
      return [..._listings]..sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeFilter == 'Location') {
      return [..._listings]..sort((a, b) => a.location.compareTo(b.location));
    }
    return _listings;
  }

  Future<void> fetchListings() async {
    isLoading = true;
    notifyListeners();

    try {
      _listings = await listingService.getListings();
    } catch (e) {
      print("Error fetching listings: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void setFilter(String? filter) {
    _activeFilter = filter;
    notifyListeners();
  }
}
