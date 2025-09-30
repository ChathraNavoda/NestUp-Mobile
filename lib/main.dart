import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/features/auth/controllers/user_controller.dart';
import 'package:nestup/features/home/controllers/home_controller.dart';
import 'package:nestup/features/listings/services/listing_service.dart';
import 'package:provider/provider.dart';

import 'features/splash/views/splash_screen.dart';

void main() async {
  // IMPORTANT: Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for persistent storage
  await Hive.initFlutter();

  final apiClient = ApiClient(baseUrl: "http://192.168.1.101:5000/api");
  final listingService = ListingService(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeController(listingService: listingService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserController(apiClient: apiClient),
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
