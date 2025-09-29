import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontDemoPage extends StatelessWidget {
  const FontDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fontWeights = [
      FontWeight.w200, // ExtraLight
      FontWeight.w300, // Light
      FontWeight.w400, // Regular
      FontWeight.w500, // Medium
      FontWeight.w600, // SemiBold
      FontWeight.w700, // Bold
      FontWeight.w800, // ExtraBold
      FontWeight.w900, // Black
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nunito Google Fonts Demo'),
        backgroundColor: const Color(0xFFbf613c),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fontWeights.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Nunito ${fontWeights[index].toString()}',
              style: GoogleFonts.nunito(
                fontWeight: fontWeights[index],
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
