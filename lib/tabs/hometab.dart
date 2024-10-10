import 'package:dashboard/features/addFeature/add_info.dart';
import 'package:dashboard/features/addFeature/add_info_er.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> status;

  const HomeTab({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const CustomizedAppBar(),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hospital Status:",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          '${status['total']} patient(s)',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: coloredBox(
                                  '${status['er']}',
                                  'Emergency Room',
                                  Colors.purple,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: coloredBox(
                                  '${status['in']}',
                                  'Admitted',
                                  const Color.fromARGB(255, 86, 86, 175),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: coloredBox(
                                  '${status['sur_pen']}',
                                  'Needs Surgery',
                                  const Color.fromARGB(255, 243, 180, 63),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: coloredBox(
                                  '${status['sur']}',
                                  'In Surgery',
                                  const Color.fromARGB(255, 212, 35, 35),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(15.0), // Rounded corners
                            color: Colors.green,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.lightGreen,
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'Pending for discharge: ${status['dis_pen']} patient(s)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (role == 'Pre-Hospital Staff' || role == 'ER Staff')
          ? FloatingActionButton(
              onPressed: () {
                if (role == 'Pre-Hospital Staff') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addInfo(
                        onBack: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addInfoER(
                        onBack: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
              backgroundColor: Colors.cyan,
              shape: const CircleBorder(),
              elevation: 4,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 46,
              ),
            )
          : const SizedBox(),
    );
  }
}
