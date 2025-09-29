import 'package:flutter/material.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/features/home/controllers/home_controller.dart';
import 'package:nestup/features/listings/services/listing_service.dart';
import 'package:nestup/features/splash/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final apiClient = ApiClient(baseUrl: "http://192.168.1.101:5000/api");
  final listingService = ListingService(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              HomeController(listingService: listingService)..fetchListings(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
