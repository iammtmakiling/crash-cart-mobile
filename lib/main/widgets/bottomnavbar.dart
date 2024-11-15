import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/features/addFeature/add_info.dart';
import 'package:dashboard/features/addFeature/add_info_er.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themePrimaryColor = Theme.of(context).primaryColor;
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Material(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                items: [
                  _buildBottomNavigationBarItem(LucideIcons.home,
                      LucideIcons.home, 0, 'Home', themePrimaryColor, context),
                  _buildBottomNavigationBarItem(
                      LucideIcons.fileText,
                      LucideIcons.fileText,
                      1,
                      'Records',
                      themePrimaryColor,
                      context),
                  if (userProvider.role == 'Pre-Hospital Staff' ||
                      userProvider.role == 'ER Staff')
                    BottomNavigationBarItem(
                      icon: SizedBox(width: 0, height: 0),
                      label: '',
                    ),
                  _buildBottomNavigationBarItem(
                      LucideIcons.history,
                      LucideIcons.history,
                      2,
                      'History',
                      themePrimaryColor,
                      context),
                  _buildBottomNavigationBarItem(
                      LucideIcons.user,
                      LucideIcons.user,
                      3,
                      'Profile',
                      themePrimaryColor,
                      context),
                ],
                selectedItemColor: themePrimaryColor,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Positioned(
              bottom: 40, // Adjust based on your design
              child: _buildAddButton(context),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData activeIcon,
    IconData inactiveIcon,
    int index,
    String label,
    Color activeColor,
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            currentIndex == index ? activeIcon : inactiveIcon,
            size: currentIndex == index ? 24.0 : 20.0,
            color: currentIndex == index ? activeColor : Colors.grey,
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: currentIndex == index ? activeColor : Colors.grey,
                  fontWeight: currentIndex == index ? FontWeight.bold : null,
                ),
          ),
        ],
      ),
      label: '',
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // if (userProvider.role == 'Pre-Hospital Staff' ||
    //     userProvider.role == 'ER Staff') {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (userProvider.role == 'Pre-Hospital Staff') {
                return addInfo(
                  onBack: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainNavigation()),
                  ),
                );
              } else {
                return AddInfoER(
                  onBack: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainNavigation()),
                  ),
                );
              }
            },
          ),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      child: const Icon(LucideIcons.plus, color: Colors.white, size: 32),
    );
  }
  //   return SizedBox.shrink();
  // }
}
