import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/task_provider.dart';
import '../const/color.dart';
import '../const/dimention.dart';
import '../const/images.dart';
import '../drawer/drawer_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<TasksProvider>(context, listen: false).updateTimeOfDay();
      Provider.of<TasksProvider>(context, listen: false).loadTasks();
    });
  }
  int selectName = 0;
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
  final _titleController = TextEditingController();
  int _currentId = 0;
  String _searchText = '';
  int _statusFilter = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: const DrawerPage(),
        backgroundColor: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn?  Colors.grey.shade900:Colors.white,
        body: Consumer2<TasksProvider,ThemeNotifier>(
          builder: (context, value,themeProvider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [themeBlueLight, themeDarkBlue], begin: Alignment.topRight, end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.035),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HeightGap(gap: 0.02),
                                Row(
                                  children: [
                                    const WidthGap(gap: 0.02),
                                    InkWell(
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        child: Image.asset(AppAssets.box, height: 28)),
                                    const Spacer(),
                                    Consumer<ThemeNotifier>(
                                      builder: (context, themeNotifier, child) {
                                        return Switch(
                                          activeColor:themeNotifier.isDarkModeOn? Colors.green:Colors.grey.shade800,
                                          value: themeNotifier.isDarkModeOn,
                                          onChanged: (value) {
                                            themeNotifier.toggleTheme();
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const HeightGap(gap: 0.02),
                                Text(
                                    value.timeOfDay == 'Morning'
                                        ? "Good morning !"
                                        : value.timeOfDay == 'Afternoon'
                                        ? "Good afternoon !"
                                        : value.timeOfDay == 'Night'
                                        ? "Good night !"
                                        : "Good evening !",
                                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: Colors.white)),
                                 const HeightGap(gap: 0.01),
                               Text(
                                  value.timeOfDay == 'Night'
                                      ? ""
                                      : value.timeOfDay == 'Morning'
                                      ? "Let’s get your day started"
                                      : "Let’s complete your day",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(right: 10, top: screenHeight(context) * 0.14, child: Image.asset((value.timeOfDay == 'Morning' || value.timeOfDay == 'Afternoon') ? AppAssets.morning : AppAssets.night, height: 140))
                    ],
                  ),
                  const HeightGap(gap: 0.02),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width/2-36,
                            child: TextFormField(
                              style:   TextStyle(
                                color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                fontSize: 14, // Adjust as needed
                                fontFamily: 'Outfit', // Adjust as needed
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchText = value;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10),
                                enabled: true,
                                filled: true,
                                fillColor: themeProvider.isDarkModeOn ? Colors.black :Colors.grey.shade200,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Color(0xFFC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(width: 0.50, color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: "Search...",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF7B7B7B),
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, ),
                        child: Container(
                          width: MediaQuery.of(context).size.width/2-36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: themeProvider.isDarkModeOn ? Colors.black :Colors.grey.shade200
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                            child: DropdownButtonFormField<int>(
                              value: _statusFilter,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _statusFilter = value!;
                                });
                              },
                              items:   [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('All Task',style: TextStyle(fontFamily: "Outfit",
                                    color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                  ),),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Completed',style: TextStyle(fontFamily: "Outfit",
                                    color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                  )),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Not Completed',style: TextStyle(fontFamily: "Outfit",
                                    color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const HeightGap(gap: 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.03),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkModeOn ? Colors.black :Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 1),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Consumer<TasksProvider>(
                          builder: (context, provider, _) {
                            List<Task> filteredTasks = provider.tasks;
                            if (_searchText.isNotEmpty) {
                              filteredTasks = filteredTasks
                                  .where((task) => task.title.toLowerCase().contains(_searchText.toLowerCase()))
                                  .toList();
                            }
                            if (_statusFilter != 0) {
                              filteredTasks = filteredTasks.where((task) => _statusFilter == 1 ? task.isCompleted : !task.isCompleted).toList();
                            }

                            // Check if filteredTasks is empty, then show "Data not found" text
                            if (filteredTasks.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Data not found",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Outfit",
                                      color: Colors.red, // Customize color as needed
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(),
                              shrinkWrap: true,
                              primary: true,
                              itemCount: filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = filteredTasks[index];
                                return  ListTile(
                                  // contentPadding: EdgeInsets.only(),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontFamily: "Outfit",
                                      color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    // fillColor: MaterialStateProperty.all<Color>(themeBlue),
                                    activeColor: Colors.green,
                                    // focusColor: Colors.green,
                                    value: task.isCompleted,
                                    onChanged: (value) {
                                      task.isCompleted = value!;
                                      provider.updateTask(task);
                                    },
                                  ),
                                  onTap: () {
                                    _titleController.text = task.title;
                                    _currentId = task.id;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Task'),
                                          content: TextField(
                                            controller: _titleController,
                                            decoration: const InputDecoration(hintText:'Task'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child:   Text('Cancel',style: TextStyle(fontFamily: "Outfit",
                                                color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                              )),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                provider.updateTask(Task(
                                                  id: _currentId,
                                                  title: _titleController.text,
                                                  isCompleted: task.isCompleted,
                                                ));
                                                Navigator.pop(context);
                                              },
                                              child:   Text('Save',style: TextStyle(fontFamily: "Outfit",
                                                color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                              )),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                provider.deleteTask(task);
                                                Navigator.pop(context);
                                              },
                                              child:   Text('Delete',style: TextStyle(fontFamily: "Outfit",
                                                color: themeProvider.isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                                              )),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                  const HeightGap(gap: 0.04),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding:   const EdgeInsets.all(15.0),
          child: Consumer<TasksProvider>(
            builder: (context,provider,child){
              return  Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  color: themeBlue
                  // color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn?  Colors.black :Colors.grey.shade200,
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Task',style: TextStyle(fontFamily: "Outfit",
                            color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                          )),
                          content: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(hintText: 'Task',hintStyle: TextStyle(fontFamily: "Outfit",
                              color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                            )),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',style: TextStyle(fontFamily: "Outfit",
                                color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                              )),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.addTask(Task(
                                  id: provider.tasks.length==0?1: provider.tasks[provider.tasks.length-1].id + 1,
                                  // id: filteredTasks.length,
                                  title: _titleController.text,
                                ));
                                _titleController.clear();
                                Navigator.pop(context);
                              },
                              child: Text('Save',style: TextStyle(fontFamily: "Outfit",
                                color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.white:const Color(0xFF7B7B7B),
                              )),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Center(child: Text("Add New Task",style: TextStyle(color: Colors.white),)),
                ),
              );
            },
          ),
        ),
      ),

    );
  }
}