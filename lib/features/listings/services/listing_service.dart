import 'package:nestup/features/home/models/listing_model.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';

class ListingService {
  final ApiClient apiClient;

  ListingService({required this.apiClient});

  Future<List<Listing>> getListings() async {
    final data = await apiClient.get(Endpoints.listings);
    return (data as List).map((json) => Listing.fromJson(json)).toList();
  }
}
