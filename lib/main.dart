import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';

// Global theme mode notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAgU4xtwQRPyKUsLZk6XOPlNxqKr_5OeO8",
      authDomain: "travel-app-99663.firebaseapp.com",
      projectId: "travel-app-99663",
      storageBucket: "travel-app-99663.firebasestorage.app",
      messagingSenderId: "989498782006",
      appId: "1:989498782006:web:9d17398fc7c685242dc397",
    ),
  );
  runApp(TravelPlannerApp());
}

class TravelPlannerApp extends StatelessWidget {
  const TravelPlannerApp({super.key}); 
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel Planner',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light, // Light theme
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark, // Dark theme
            primarySwatch: Colors.deepPurple,
          ),
          themeMode: currentMode, // Dynamically switches between themes
          home: SplashScreen(),
        );
      },
    );
  }
}
