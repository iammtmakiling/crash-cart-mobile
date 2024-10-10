import 'package:dashboard/globals.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MiniAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(firstName[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Dr $name",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  occupation,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  userID,
                  style: const TextStyle(
                      fontSize: 18, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                UserDetail(
                    icon: Icons.person, detailTitle: "Gender", detailText: sex),
                UserDetail(
                    icon: Icons.cake,
                    detailTitle: "Birthday",
                    detailText: birthday),
                UserDetail(
                    icon: Icons.work, detailTitle: "Role", detailText: role),
                UserDetail(
                    icon: Icons.local_hospital,
                    detailTitle: "Hospital Id",
                    detailText: hospitalID),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [

                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
