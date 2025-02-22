import 'package:flutter/material.dart';

class TreeWidget extends StatelessWidget {
  final String stage;

  const TreeWidget({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.green,
      child: Center(child: Text(stage)),
    );
  }
}