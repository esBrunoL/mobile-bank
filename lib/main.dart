import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/welcome_screen.dart';

/// Main entry point of the Flutter Bank Application
/// 
/// This function initializes the Flutter framework and runs the app.
/// It also configures system UI overlays for a polished appearance.
void main() {
  // Ensure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI overlays (status bar and navigation bar)
  // This provides a consistent look across the entire app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const FlutterBankApp());
}

/// Root widget of the Flutter Bank Application
/// 
/// This widget sets up the MaterialApp with custom theming,
/// navigation configuration, and defines the home screen.
/// The theme is designed to provide a professional, trustworthy
/// banking experience with a modern blue color scheme.
class FlutterBankApp extends StatelessWidget {
  const FlutterBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Flutter Bank',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration for consistent styling throughout the app
      theme: ThemeData(
        // Primary color scheme - using professional blue tones
        // Blue is commonly associated with trust, security, and professionalism
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1565C0), // Deep blue
        primaryColorLight: const Color(0xFF5E92F3),
        primaryColorDark: const Color(0xFF003C8F),
        
        // Accent color for highlights and interactive elements
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          secondary: const Color(0xFF00897B), // Teal for secondary actions
          brightness: Brightness.light,
        ),
        
        // AppBar theme - consistent styling for all app bars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        
        // Elevated button theme - for primary action buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Text button theme - for secondary actions
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1565C0),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Input decoration theme - for any form fields (if needed in future)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF1565C0),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        
        // Icon theme - consistent icon styling
        iconTheme: const IconThemeData(
          color: Color(0xFF1565C0),
        ),
        
        // Typography - consistent text styling across the app
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF424242),
          ),
        ),
        
        // Scaffold background color - light gray for subtle contrast
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        
        // Visual density for comfortable touch targets on mobile
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Use Material 3 design principles
        useMaterial3: true,
      ),
      
      // Home screen - the first screen users see when opening the app
      // Starting with WelcomeScreen as specified in requirements
      home: const WelcomeScreen(),
    );
  }
}
