// import 'package:dashboard/core/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProfileTab extends StatelessWidget {
//   const ProfileTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
//       child: Column(
//         children: [
//           const Text(
//             "Account Settings",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 24),
//           CircleAvatar(
//             radius: 48,
//             backgroundColor: Colors.cyan,
//             child: Text(
//               "${userProvider.firstName.isNotEmpty ? userProvider.firstName[0] : ''}${userProvider.lastName.isNotEmpty ? userProvider.lastName[0] : ''}",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 40,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "${userProvider.firstName} ${userProvider.lastName}",
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             userProvider.email,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 32),
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade200),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Column(
//               children: [
//                 // AccountInfoRow(
//                 //   title: "Phone Number:",
//                 //   info: userProvider.devices.isNotEmpty
//                 //       ? userProvider
//                 //           .devices[0] // Assuming first device is phone number
//                 //       : "Not Available",
//                 // ),
//                 const AccountInfoRow(
//                   title: "Date Joined:",
//                   info: Text(
//                       "17, March 2024"), // Replace with actual join date if available
//                 ),
//                 AccountInfoRow(
//                   title: "Password:",
//                   info: GestureDetector(
//                     onTap: () {
//                       // Navigate to Change Password Page
//                     },
//                     child: const Text(
//                       "Change Password",
//                       style: TextStyle(
//                         color: Colors.purple,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton(
//             onPressed: () {
//               // Log out logic here
//             },
//             style: ElevatedButton.styleFrom(
//               // backgroundColor: Colors.purple, // Adjust color as needed
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text(
//               "Log out",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AccountInfoRow extends StatelessWidget {
//   final String title;
//   final Widget info;

//   const AccountInfoRow({
//     super.key,
//     required this.title,
//     required this.info,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           Flexible(
//             child: info,
//           ),
//         ],
//       ),
//     );
//   }
// }
