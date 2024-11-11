import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/screens/RecordsScreen/widgets/_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> myRecords;
  final List<Map<String, dynamic>> otherRecords;

  const RecordsScreen({
    super.key,
    required this.myRecords,
    required this.otherRecords,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  toolbarHeight: kToolbarHeight + 20,
                  title: const Center(
                    child: Text(
                      "RECORDS",
                    ),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          (userProvider.role.length >= 6 &&
                                  userProvider.role.substring(
                                          0, userProvider.role.length - 6) ==
                                      "ER")
                              ? "Emergency Room"
                              : userProvider.role,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Others',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    MyRecords(myRecords: myRecords, isSolo: false),
                    OtherRecords(otherRecords: otherRecords, isSolo: false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
