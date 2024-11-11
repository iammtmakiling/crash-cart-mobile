// import 'package:dashboard/core/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'tabs.dart';
// import '../widgets/widgets.dart';

// class StreamTab extends StatelessWidget {
//   final List<Map<String, dynamic>> myPhase;
//   final List<Map<String, dynamic>> otherPhases;

//   const StreamTab({
//     super.key,
//     required this.myPhase,
//     required this.otherPhases,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     return SafeArea(
//       child: Column(
//         children: [
//           Expanded(
//             child: DefaultTabController(
//               length: 2, // Number of tabs
//               child: Scaffold(
//                 appBar: AppBar(
//                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                   toolbarHeight: 10,
//                   bottom: TabBar(
//                     tabs: [
//                       Tab(
//                         child: Text(
//                           (userProvider.role.length >= 6 &&
//                                   userProvider.role.substring(
//                                           0, userProvider.role.length - 6) ==
//                                       "ER")
//                               ? "Emergency Room"
//                               : userProvider.role,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.cyan,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const Tab(
//                         child: Text(
//                           'Others',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.cyan,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 body: TabBarView(
//                   children: [
//                     myPhaseTab(myPhase: myPhase, isSolo: false),
//                     otherPhasesTab(otherPhase: otherPhases, isSolo: false),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
