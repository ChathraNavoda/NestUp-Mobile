import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/core/theme/app_colors.dart';
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
      title: 'NestUp',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.light,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.light,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primary),
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: AppColors.dark,
            displayColor: AppColors.dark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.light,
            textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.accent.withOpacity(0.3),
          selectedColor: AppColors.primary,
          labelStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            color: AppColors.light,
          ),
          secondaryLabelStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.brandPrimary, width: 1.2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
