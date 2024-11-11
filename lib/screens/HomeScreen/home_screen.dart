// ignore_for_file: prefer_const_constructors

import 'package:dashboard/features/addFeature/add_info.dart';
import 'package:dashboard/features/addFeature/add_info_er.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> status;

  const HomeScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderSection(),
          TotalPatientsCard(total: status['total']),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(16),
              children: [
                StatusCard(
                  count: status['er'],
                  title: 'Emergency Room',
                  color: Colors.lightBlue.shade100,
                  icon: LucideIcons.alertCircle,
                ),
                StatusCard(
                  count: status['in'],
                  title: 'Admission Ward',
                  color: Colors.purple.shade100,
                  icon: LucideIcons.bed,
                ),
                StatusCard(
                  count: status['sur_pen'],
                  title: 'Needs Surgery',
                  color: Colors.red.shade100,
                  icon: LucideIcons.heart,
                ),
                StatusCard(
                  count: status['sur'],
                  title: 'Operation Room',
                  color: Colors.green.shade100,
                  icon: LucideIcons.heartPulse,
                ),
                StatusCard(
                  count: status['dis_pen'],
                  title: 'For Discharge',
                  color: Colors.amber.shade100,
                  icon: LucideIcons.doorOpen,
                ),
                StatusCard(
                  count: 0, // Replace with actual data for old records
                  title: 'View Old Records',
                  color: Colors.grey.shade300,
                  icon: LucideIcons.archive,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: RoleBasedFAB(),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wednesday, 5 Oct",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            "Good day, Doc Makiling!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}

class TotalPatientsCard extends StatelessWidget {
  final int total;

  const TotalPatientsCard({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$total',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "Total Patients",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Icon(LucideIcons.arrowRightCircle, color: Colors.blue.shade600),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final int count;
  final String title;
  final Color color;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.count,
    required this.title,
    required this.color,
    required this.icon,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Theme.of(context).iconTheme.color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '$count patients',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(LucideIcons.arrowRightCircle, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class RoleBasedFAB extends StatelessWidget {
  const RoleBasedFAB({super.key});

  @override
  Widget build(BuildContext context) {
    if (role == 'Pre-Hospital Staff' || role == 'ER Staff') {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (role == 'Pre-Hospital Staff') {
                  return addInfo(
                    onBack: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainNavigation()),
                    ),
                  );
                } else {
                  return addInfoER(
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
        backgroundColor: Colors.cyan,
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 36),
      );
    }
    return const SizedBox();
  }
}
