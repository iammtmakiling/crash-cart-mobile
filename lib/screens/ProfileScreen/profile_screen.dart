import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/screens/ProfileScreen/widgets/info_row.dart';
import 'package:dashboard/screens/SigninScreen/signin_screen.dart';
import 'package:dashboard/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: mainAppBar(context, "USER PROFILE"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 48,
                backgroundColor:
                    AppColors.primary, // Assuming cyan is accent color
                child: Text(
                  "${userProvider.firstName.isNotEmpty ? userProvider.firstName[0] : ''}${userProvider.lastName.isNotEmpty ? userProvider.lastName[0] : ''}",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.background, // Assuming this is white
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${userProvider.firstName} ${userProvider.lastName}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                userProvider.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Divider(
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    AccountInfoRow(
                      title: "Username:",
                      info: userProvider.username,
                    ),
                    AccountInfoRow(
                      title: "Department:",
                      info: userProvider.department,
                    ),
                    AccountInfoRow(
                      title: "User ID:",
                      info: userProvider.userID,
                    ),
                    AccountInfoRow(
                      title: "Email:",
                      info: userProvider.email,
                    ),
                    AccountInfoRow(
                      title: "Sex:",
                      info: userProvider.sex,
                    ),
                    AccountInfoRow(
                      title: "Birthday:",
                      info: userProvider.birthday,
                    ),
                    AccountInfoRow(
                      title: "Occupation:",
                      info: userProvider.occupation,
                    ),
                    AccountInfoRow(
                      title: "Role:",
                      info: userProvider.role,
                    ),
                    AccountInfoRow(
                      title: "Hospital ID:",
                      info: userProvider.hospitalID,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          userProvider.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Log out",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
