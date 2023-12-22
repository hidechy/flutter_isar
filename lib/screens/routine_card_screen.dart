import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:test_isar_sample/screens/home_screen.dart';

import '../collections/routine.dart';

class RoutineCardScreen extends StatefulWidget {
  const RoutineCardScreen({super.key, required this.isar});

  final Isar isar;

  @override
  State<RoutineCardScreen> createState() => _RoutineCardScreenState();
}

class _RoutineCardScreenState extends State<RoutineCardScreen> {
  List<Routine>? routines = [];

  ///
  @override
  void initState() {
    super.initState();
    _readRoutine();
  }

  ///
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
                  child: const Text('add routine'),
                ),
              ],
            ),
            Expanded(
              child: (routines == null)
                  ? Container()
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(routines![index].routineId.toString()),
                                      Text(
                                        (routines![index].category.value == null)
                                            ? ''
                                            : routines![index].category.value!.name,
                                      ),
                                      Text(routines![index].title),
                                      Text(routines![index].startTime),
                                      Text(routines![index].day),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.info_outline_rounded),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Container(),
                      itemCount: routines!.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _readRoutine() async {
    final routineCollection = widget.isar.routines;

    final getRoutines = await routineCollection.where().findAll();

    setState(() {
      routines = getRoutines;
    });
  }
}
