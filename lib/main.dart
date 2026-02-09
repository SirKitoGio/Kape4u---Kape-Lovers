import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // This forces the phone frame to appear
      builder: (context) => const JournalApp(),
    ),
  );
}

class JournalApp extends StatelessWidget {
  const JournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // These lines are required for the preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      title: 'Kape4u', 
      theme: ThemeData(
        primarySwatch: Colors.brown, 
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}