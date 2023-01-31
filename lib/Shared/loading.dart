import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: SpinKitFoldingCube(
          color: Colors.blueAccent,
          size: 50,
        ),
      ),
    );
  }
}
