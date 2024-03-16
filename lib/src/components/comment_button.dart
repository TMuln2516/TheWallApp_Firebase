import 'package:flutter/material.dart';

class MyCommentButton extends StatelessWidget {
  void Function()? onTap;
  MyCommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.comment),
    );
  }
}
