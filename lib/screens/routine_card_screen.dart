import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:test_isar_sample/screens/home_screen.dart';
import 'package:test_isar_sample/screens/update_routine.dart';

import '../collections/routine.dart';

class RoutineCardScreen extends StatefulWidget {
  const RoutineCardScreen({super.key, required this.isar});

  final Isar isar;

  @override
  State<RoutineCardScreen> createState() => _RoutineCardScreenState();
}

class _RoutineCardScreenState extends State<RoutineCardScreen> {
  List<Routine>? routines = [];

  final TextEditingController _searchEditingController = TextEditingController();

  bool searching = false;

  ///
  @override
  void initState() {
    super.initState();
//    _readRoutine();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                onChanged: (value) {
                  _searchRoutineByName(searchText: value);
                },
                controller: _searchEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search Text',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar)),
                    );
                  },
                  child: const Text('add routine'),
                ),
              ],
            ),
            FutureBuilder<List<Widget>>(
              future: _displayRoutineCard(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Column(children: snapshot.data!),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  ///
  Future<void> _readRoutine() async {
    final routineCollection = widget.isar.routines;

    final getRoutines = await routineCollection.where().findAll();

    setState(() {
      routines = getRoutines;
    });
  }

  ///
  Future<List<Widget>> _displayRoutineCard() async {
    if (searching) {
      await _searchRoutineByName(searchText: _searchEditingController.text);
    } else {
      await _readRoutine();
    }

    List<Widget> list = [];

    for (var i = 0; i < routines!.length; i++) {
      list.add(
        Card(
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routines![i].routineId.toString()),
                      Text(
                        (routines![i].category.value == null) ? '' : routines![i].category.value!.name,
                      ),
                      Text(routines![i].title),
                      Text(routines![i].startTime),
                      Text(routines![i].day),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateRoutine(
                          isar: widget.isar,
                          routine: routines![i],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return list;
  }

  ///
  _searchRoutineByName({required String searchText}) async {
    searching = true;

    final routineCollection = widget.isar.routines;
    final searchResults = await routineCollection.filter().titleContains(searchText).findAll();

    setState(() {
      routines = searchResults;
    });
  }
}
