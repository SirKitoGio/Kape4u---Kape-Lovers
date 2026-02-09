import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; 
import 'coffee_list_screen.dart';
import 'map_screen.dart'; 
import 'deals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Start on the Coffee List (Index 1)

  // The list of screens to switch between
  final List<Widget> _screens = [
    const Center(child: Text("Favorites (Coming Soon)")), 
    const CoffeeListScreen(),                             
    const DealsScreen(),          
    const MapScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extending body ensures the content goes BEHIND our floating bar
      extendBody: true, 
      backgroundColor: const Color(0xFFF8F5F2),
      
      body: Stack(
        children: [
          // 1. THE MAIN CONTENT
          _screens[_currentIndex],

          // 2. THE FLOATING BOTTOM BAR
          Positioned(
            left: 24,
            right: 24,
            bottom: 30, // Distance from bottom of phone
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass effect
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4E342E).withOpacity(0.85), // Dark Coffee Brown
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavBarItem(Icons.star_rounded, 0),
                      _buildNavBarItem(Icons.coffee, 1),
                      _buildNavBarItem(Icons.notifications_active_rounded, 2),
                      _buildNavBarItem(Icons.map_rounded, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Adds a small vibration when tapped
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8D6E63) : Colors.transparent, // Lighter brown if selected
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFFFD180) : Colors.white.withOpacity(0.6), // Gold if selected, dim white if not
          size: 26,
        ),
      ),
    );
  }
}