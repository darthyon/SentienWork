import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'screens/main_app_screen.dart';

void main() {
  // Set status bar to light content (white icons/text)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  
  runApp(const SentienWorkApp());
}

class SentienWorkApp extends StatelessWidget {
  const SentienWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SentienWork',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: GoogleFonts.dmSansTextTheme(),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.grey[600],
          textTheme: CupertinoTextThemeData(
            actionTextStyle: TextStyle(color: Colors.grey[600]),
            dateTimePickerTextStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
      home: const OnboardingFlow(),
      routes: {
        '/home': (context) => const MainAppScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
