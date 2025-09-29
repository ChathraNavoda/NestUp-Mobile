import 'package:flutter/material.dart';
import 'package:nestup/features/splash/views/splash_screen.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'features/home/controllers/home_controller.dart';
import 'features/listings/services/listing_service.dart';

void main() {
  final apiClient = ApiClient(
    baseUrl: "http://192.168.1.101:5000/api",
  ); // your backend IP
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
