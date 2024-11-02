import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themePrimaryColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            _buildBottomNavigationBarItem(LucideIcons.home, LucideIcons.home, 0,
                'Home', themePrimaryColor),
            _buildBottomNavigationBarItem(LucideIcons.fileText,
                LucideIcons.fileText, 1, 'Records', themePrimaryColor),
            _buildBottomNavigationBarItem(LucideIcons.history,
                LucideIcons.history, 2, 'History', themePrimaryColor),
            _buildBottomNavigationBarItem(LucideIcons.user, LucideIcons.user, 3,
                'Profile', themePrimaryColor),
          ],
          selectedItemColor: themePrimaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Removes shadow that could look like a border
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData activeIcon,
      IconData inactiveIcon, int index, String label, Color activeColor) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            currentIndex == index ? activeIcon : inactiveIcon,
            size: 20.0,
            color: currentIndex == index ? activeColor : Colors.grey,
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: currentIndex == index ? activeColor : Colors.grey,
            ),
          ),
        ],
      ),
      label: '',
    );
  }
}
