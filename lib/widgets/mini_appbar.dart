import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/screens/SigninScreen/signin_screen.dart';
import 'package:dashboard/screens/login_page.dart';
import 'package:flutter/material.dart';

class MiniAppBar extends StatefulWidget {
  const MiniAppBar({super.key});

  @override
  MiniAppBarState createState() => MiniAppBarState();
}

class MiniAppBarState extends State<MiniAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text(
                  'CrashCart',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutConfirmationDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Are you sure you want to logout?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel button
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Colors.cyan),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
              ),
              // Confirm button
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Colors.cyan),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.cyan),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    _logout(context);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _logout(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const SignInScreen()),
    (Route<dynamic> route) => false,
  );
}
