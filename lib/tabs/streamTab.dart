import 'package:dashboard/globals.dart';
import 'package:flutter/material.dart';
import 'tabs.dart';
import '../widgets/widgets.dart';

class StreamTab extends StatelessWidget {
  final List<Map<String, dynamic>> myPhase;
  final List<Map<String, dynamic>> otherPhases;

  const StreamTab({
    super.key,
    required this.myPhase,
    required this.otherPhases,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const MiniAppBar(),
          Expanded(
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight: 10,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          // Safely accessing role with a length check
                          (role.length >= 6 &&
                                  role.substring(0, role.length - 6) == "ER")
                              ? "Emergency Room"
                              : role,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Tab(
                        child: Text(
                          'Others',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    myPhaseTab(myPhase: myPhase, isSolo: false),
                    otherPhasesTab(otherPhase: otherPhases, isSolo: false),
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
