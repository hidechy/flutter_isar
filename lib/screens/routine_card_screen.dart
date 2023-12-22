import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:test_isar_sample/screens/home_screen.dart';

class RoutineCardScreen extends StatefulWidget {
  const RoutineCardScreen({super.key, required this.isar});

  final Isar isar;

  @override
  State<RoutineCardScreen> createState() => _RoutineCardScreenState();
}

class _RoutineCardScreenState extends State<RoutineCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isar: widget.isar),
                      ),
                    );
                  },
                  child: Text('add routine'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
