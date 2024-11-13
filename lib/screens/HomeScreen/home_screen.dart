// ignore_for_file: prefer_const_constructors

import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/features/addFeature/add_info.dart';
import 'package:dashboard/features/addFeature/add_info_er.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:dashboard/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> status;

  const HomeScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                          ),
                      children: [
                        TextSpan(text: "Good day, "),
                        TextSpan(
                          text: "Doc Makiling!",
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Wednesday, 5 Oct",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("Hospital Status",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Icon(LucideIcons.refreshCcw,
                      color: Theme.of(context).iconTheme.color),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: EdgeInsets.zero,
                children: [
                  StatusCard(
                    count: status['total'],
                    title: 'Total Patients',
                    color: const Color(0xFFBDEBF6),
                    iconColor: const Color(0xFF2FADC7),
                    icon: LucideIcons.users,
                  ),
                  StatusCard(
                    count: status['er'],
                    title: 'Emergency Room',
                    color: const Color(0xFFFFF6CF), //FFF6CF
                    iconColor: const Color(0xFFF7D326), //F7D326
                    icon: LucideIcons.siren,
                  ),
                  StatusCard(
                    count: status['in'],
                    title: 'Admission Ward',
                    color: const Color(0xFFC2ADFF),
                    icon: LucideIcons.bed,
                    iconColor: const Color(0xFF6A48CC),
                  ),
                  StatusCard(
                    count: status['sur_pen'],
                    title: 'Needs Surgery',
                    color: const Color(0xFFF6BEBE),
                    icon: LucideIcons.activity,
                    iconColor: const Color(0xFFE57777),
                  ),
                  StatusCard(
                    count: status['sur'],
                    title: 'Operation Room',
                    color: const Color(0xFFFFE1B6),
                    icon: LucideIcons.heartPulse,
                    iconColor: const Color(0xFFFFB752),
                  ),
                  StatusCard(
                    count: status['dis_pen'],
                    title: 'For Discharge',
                    color: Colors.green.shade100,
                    icon: LucideIcons.doorOpen,
                    iconColor: Colors.green.shade600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: RoleBasedFAB(),
    );
  }
}

class StatusCard extends StatelessWidget {
  final int count;
  final String title;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const StatusCard({
    super.key,
    required this.count,
    required this.title,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '$count patients',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// class RoleBasedFAB extends StatelessWidget {
//   const RoleBasedFAB({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (role == 'Pre-Hospital Staff' || role == 'ER Staff') {
//       return FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 if (role == 'Pre-Hospital Staff') {
//                   return addInfo(
//                     onBack: () => Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const MainNavigation()),
//                     ),
//                   );
//                 } else {
//                   return addInfoER(
//                     onBack: () => Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const MainNavigation()),
//                     ),
//                   );
//                 }
//               },
//             ),
//           );
//         },
//         backgroundColor: Colors.cyan,
//         child: const Icon(LucideIcons.plus, color: Colors.white, size: 36),
//       );
//     }
//     return const SizedBox();
//   }
// }
