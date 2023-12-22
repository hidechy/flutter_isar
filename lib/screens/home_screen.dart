import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../collections/category.dart';
import '../collections/routine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.isar});

  final Isar isar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//  List<String> categories = ['work', 'school', 'home'];
//String dropdownValue = 'work';

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
    _readCategory();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Routine')),
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
                      // items: categories.map<DropdownMenuItem<String>>(
                      //   (String nvalue) {
                      //     return DropdownMenuItem<String>(
                      //       value: nvalue,
                      //       child: Text(nvalue),
                      //     );
                      //   },
                      // ).toList(),

                      items: categories?.map<DropdownMenuItem<Category>>(
                        (Category nvalue) {
                          return DropdownMenuItem<Category>(
                            value: nvalue,
                            child: Text(nvalue.name),
                          );
                        },
                      ).toList(),

                      // onChanged: (String? value) {
                      //   setState(() {
                      //     dropdownValue = value!;
                      //   });
                      // },

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
                    _addRoutine();
                  },
                  child: const Text('Add'),
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
  Future<void> _addRoutine() async {
    final routineCollection = widget.isar.routines;

    final newRoutine = Routine()
      ..title = _titleEditingController.text
      ..startTime = _timeEditingController.text
      ..day = dropdownDay
      ..category.value = dropdownValue;

    await widget.isar.writeTxn(() async {
      await routineCollection.put(newRoutine);
    });

    _titleEditingController.clear();
    _timeEditingController.clear();

    dropdownDay = 'Sunday';
    dropdownValue = null;
  }
}
