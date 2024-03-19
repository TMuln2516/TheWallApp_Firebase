import 'package:flutter/material.dart';

class MyDeleteButton extends StatelessWidget {
  void Function()? onTap;
  MyDeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.highlight_remove),
    );
  }
}
