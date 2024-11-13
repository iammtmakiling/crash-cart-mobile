import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/screens/RecordsScreen/widgets/_widget.dart';
import 'package:dashboard/widgets/main_appbar.dart';
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
    final role = userProvider.role;
    final roleDisplay = role.endsWith("ER") ? "Emergency Room" : role;

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: mainAppBar(context, "RECORDS"),
          body: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: roleDisplay),
                  Tab(text: 'Others'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MyRecords(myRecords: myRecords, isSolo: false),
                    OtherRecords(otherRecords: otherRecords, isSolo: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
