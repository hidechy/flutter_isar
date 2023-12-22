import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../collections/category.dart';
import '../collections/routine.dart';

class UpdateRoutine extends StatefulWidget {
  const UpdateRoutine({super.key, required this.isar, required this.routine});

  final Isar isar;
  final Routine routine;

  @override
  State<UpdateRoutine> createState() => _UpdateRoutineState();
}

class _UpdateRoutineState extends State<UpdateRoutine> {
  List<Category>? categories;
  Category? dropdownValue;

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _timeEditingController = TextEditingController();

  List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  String dropdownDay = 'Sunday';

  final TextEditingController _newCategoryEditingController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  ///
  @override
  void initState() {
    super.initState();
    _setUpdateRoutine();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Routine')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      value: dropdownValue,
                      dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: categories?.map<DropdownMenuItem<Category>>(
                        (Category nvalue) {
                          return DropdownMenuItem<Category>(
                            value: nvalue,
                            child: Text(nvalue.name),
                          );
                        },
                      ).toList(),
                      onChanged: (Category? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('New Category'),
                              content: TextFormField(
                                controller: _newCategoryEditingController,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (_newCategoryEditingController.text.isNotEmpty) _addCategory(widget.isar);
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Title'),
              TextFormField(
                controller: _titleEditingController,
              ),
              const SizedBox(height: 30),
              const Text('Start Time'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timeEditingController,
                      enabled: false,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _selectedTime();
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Day'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      value: dropdownDay,
                      dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: days.map<DropdownMenuItem<String>>(
                        (String nvalue) {
                          return DropdownMenuItem<String>(
                            value: nvalue,
                            child: Text(nvalue),
                          );
                        },
                      ).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownDay = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _updateRoutine();
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _selectedTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;

      setState(() {
        _timeEditingController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
    }
  }

  ///
  Future<void> _addCategory(Isar isar) async {
    final newCategory = Category()..name = _newCategoryEditingController.text;

    await isar.writeTxn(() async {
      await isar.categorys.put(newCategory);
    });

    _newCategoryEditingController.clear();

    _readCategory();
  }

  ///
  Future<void> _readCategory() async {
    final categoryCollection = widget.isar.categorys;
    final getCategories = await categoryCollection.where().findAll();
    setState(() {
      dropdownValue = null;
      categories = getCategories;
    });
  }

  ///
  _setUpdateRoutine() async {
    await _readCategory();

    _titleEditingController.text = widget.routine.title;
    _timeEditingController.text = widget.routine.startTime;

    dropdownDay = widget.routine.day;

    // await widget.routine.category.load();
    //
    // int? getId = widget.routine.category.value?.id;
    //
    // print(widget.routine.category.value);
    //
    // setState(() {
    //   dropdownValue = categories?[getId! - 1];
    // });
  }

  ///
  _updateRoutine() async {
    final routineCollection = widget.isar.routines;

    await widget.isar.writeTxn(() async {
      final routine = await routineCollection.get(widget.routine.routineId);

      routine!
        ..title = _titleEditingController.text
        ..startTime = _timeEditingController.text
        ..day = dropdownDay
        ..category.value = dropdownValue;

      await routineCollection.put(routine);

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
