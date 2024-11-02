import 'package:flutter/material.dart';

class InfoCol extends StatelessWidget {
  final List<dynamic> itemList;
  final String title;

  const InfoCol({super.key, required this.itemList, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Use a ListView with a fixed height if you expect a specific size.
        // Otherwise, you may consider other alternatives like ListView.separated for better performance.
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            return Text(
              "- ${itemList[index]}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            );
          },
        ),
      ],
    );
  }
}
