import 'package:flutter/material.dart';

class MyLikeButton extends StatelessWidget {
  void Function()? onTap;
  final bool isLiked;
  MyLikeButton({super.key, required this.onTap, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
