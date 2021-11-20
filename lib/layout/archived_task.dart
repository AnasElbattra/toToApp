import 'package:intl/intl.dart';
import '../screens/archived_task_screen.dart';
import '../screens/done_task_screen.dart';
import 'package:sqflite/sqflite.dart';
import '../screens/new_task.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int? current = 0;
  IconData? icon = Icons.edit;
  Database? database;
  bool isBottomSheetShown = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  List<Widget> screen = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];
  List<String> title = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  @override
  void initState() {
    openDataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          title[current!],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: screen[current!],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertDatabase(
                  title: titleController.text,
                  date: dateController.text,
                  time: timeController.text)
                  .then((value) {
                Navigator.of(context).pop();
                isBottomSheetShown = false;
                setState(() {
                  icon = Icons.edit;
                });
              });
            }
            titleController.clear();
            timeController.clear();
            dateController.clear();
          } else {
            scaffoldKey.currentState!.showBottomSheet(
                  (context) =>
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Task Title',
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validator: (String? val) {
                                if (val == null || val.isEmpty) {
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Task Time',
                                  prefixIcon: Icon(Icons.watch_later),
                                  border: OutlineInputBorder())),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: dateController,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2050-10-10'),
                              ).then((value) {
                                dateController.text =
                                    DateFormat.yMMMd()
                                        .format(value!)
                                        .toString();
                              });
                            },
                            keyboardType: TextInputType.datetime,
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'date must not be empty';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Task Date',
                              prefixIcon: Icon(Icons.calendar_today_sharp),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            );
            isBottomSheetShown = true;
            setState(() {
              icon = Icons.add;
            });
          }
        },
        child: Icon(icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        selectedItemColor: Colors.white,
        //Theme.of(context).accentColor,
        //selectedIconTheme: IconThemeData(color:Colors.white ),
        selectedLabelStyle: TextStyle(color: Colors.white),

        currentIndex: current!,
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        elevation: 20,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: 'task'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.done,
              ),
              label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
              ),
              label: 'archive'),
        ],
      ),
    );
  }

  void openDataBase() async {
    database = await openDatabase(
      'ToDo.dp',
      version: 1,
      onCreate: (db, version) async {
        // When creating the db, create the table
        db
            .execute(
            'CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then(
              (value) => print('table created'),
        )
            .catchError((error) {
          print('error when creating Table ${error.toString()}');
        });
      },
      onOpen: (db) {
        print('database opened');
      },
    );
  }

  Future insertDatabase({required String title,
    required String date,
    required String time}) async {
    return await database!.transaction((txn) {
      return txn
          .rawInsert(
          'INSERT INTO Test (title , date , time , status ) VALUES ("$title" , "$date","$time","new") ')
          .then((value) {
        print('$value table inserted');
      }).catchError((error) {
        print('error in insert ${error.toString()}');
      });
    });
  }
}
