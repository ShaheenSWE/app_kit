import 'package:flutter/material.dart';

class AppRibbon extends StatelessWidget {
  const AppRibbon({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    height: 6,
    decoration: const BoxDecoration(
      color: Color(0xFF2980b9),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
  );
}
