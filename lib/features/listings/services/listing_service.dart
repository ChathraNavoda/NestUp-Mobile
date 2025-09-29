import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/network/endpoints.dart';
import 'package:nestup/features/home/models/listing_model.dart';

class ListingService {
  final ApiClient apiClient;

  ListingService({required this.apiClient});

  Future<List<Listing>> getListings() async {
    final data = await apiClient.get(Endpoints.listings);
    return data.map<Listing>((json) => Listing.fromJson(json)).toList();
  }
}
