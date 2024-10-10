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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              "- ${itemList[index]}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1,
              ),
            );
          },
        ),
      ],
    );
  }
}
