import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String name;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(),
              const SizedBox(
                height: 5,
              ),
              Text(time),
            ],
          ),
        ],
      ),
    );
  }
}
