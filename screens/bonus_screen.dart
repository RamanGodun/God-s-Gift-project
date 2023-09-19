import 'package:flutter/material.dart';
import 'package:gods_gift/screens/home_screen.dart';
import 'package:gods_gift/utils/utils.dart';

class BonusScreen extends StatelessWidget {
  const BonusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          nextScreen(context, MyHomePage());
        },
        child: const Text('Home screen'),
      )),
    );
  }
}
