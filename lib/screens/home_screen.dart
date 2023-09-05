import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_managementapp/screens/addtodo.dart';
import 'package:task_managementapp/screens/edittodo.dart';
import 'package:task_managementapp/services/notification_service.dart';

import 'package:task_managementapp/widgets/todo_card.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Select> _selected = [];
  bool? check;
  DateTime selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(context, user!),
      bottomNavigationBar: bottomnavigationbar(context),
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
            "Today               ${DateFormat.yMMMMd().format(DateTime.now())}",
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.purpleAccent,
                selectedTextColor: Colors.white,
                dateTextStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
                monthTextStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
                dayTextStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              )),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .collection("TaskDetails")
                    .snapshots(),
                builder: (context, todosnapshot) {
                  if (todosnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!todosnapshot.hasData ||
                      todosnapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                            height: 160,
                            "https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX32743770.jpg"),
                        const Text("You do not have any task yet!.",
                            style: TextStyle(color: Colors.blueGrey)),
                        const Text("Add new task to make your day productive.",
                            style: TextStyle(color: Colors.blueGrey)),
                      ],
                    );
                  }

                  return AnimationLimiter(
                    child: ListView.builder(
                        itemCount: todosnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DateTime date = DateFormat.Hm().parse(
                              todosnapshot.data!.docs[index]['start-time']);
                          var myTime = DateFormat("HH:mm").format(date);

                          //schedule notification

                          String scheduledate =
                              todosnapshot.data?.docs[index]['selectedDate'];

                          IconData icondata;
                          Color iconcolor;
                          Map<String, dynamic> tododata =
                              todosnapshot.data!.docs[index].data();

                          switch (todosnapshot.data?.docs[index]['catagory']) {
                            case "Workout":
                              icondata = Icons.run_circle;
                              iconcolor = Colors.orange;
                              break;
                            case "Meeting":
                              icondata = Icons.video_call;
                              iconcolor = Colors.blue;
                              break;
                            case "Urgent":
                              icondata = Icons.alarm;
                              iconcolor = Colors.red;
                              break;
                            case "Development":
                              icondata = Icons.developer_board;
                              iconcolor = Colors.indigo;
                              break;
                            case "Design":
                              icondata = Icons.draw;
                              iconcolor = Colors.pinkAccent;
                              break;
                            case "Market":
                              icondata = Icons.local_grocery_store;
                              iconcolor = Colors.cyan;
                              break;
                            case "Study":
                              icondata = Icons.book;
                              iconcolor = const Color.fromARGB(255, 11, 56, 52);
                              break;
                            case "Sports":
                              icondata = Icons.sports_cricket;
                              iconcolor = Colors.black;
                              break;
                            case "Gym":
                              icondata = Icons.fitness_center;
                              iconcolor = Colors.black;
                              break;
                            case "Eating":
                              icondata = Icons.fastfood;
                              iconcolor = Colors.black;
                              break;
                            case "Learning":
                              icondata = Icons.code;
                              iconcolor = Colors.black;
                              break;
                            case "Dance":
                              icondata = Icons.event;
                              iconcolor = Colors.black;
                              break;
                            case "Music":
                              icondata = Icons.music_note;
                              iconcolor = Colors.black;
                              break;
                            case "HomeWork":
                              icondata = Icons.school;
                              iconcolor = Colors.black;
                              break;

                            default:
                              icondata = Icons.work_history;
                              iconcolor = Colors.black;
                          }

                          _selected.add(Select(
                              id: todosnapshot.data!.docs[index].id,
                              checkval: false));

                          NotifyHelper().scheduleNotification(
                            int.parse(myTime.toString().split(":")[0]),
                            int.parse(myTime.toString().split(":")[1]),
                            scheduledate,
                            todosnapshot.data?.docs[index]['title'],
                            index,
                            todosnapshot.data?.docs[index]['description'],
                          );

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: InkWell(
                                    onTap: () {
                                      // print(myTime);
                                      // print(parsedDate);
                                      // print(parsedTime);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditTodo(
                                                  user: user,
                                                  data: tododata,
                                                  date: selectedDate,
                                                  id: todosnapshot
                                                      .data!.docs[index].id)));
                                    },
                                    child: (todosnapshot.data?.docs[index]
                                                    ['selectedDate'] ==
                                                DateFormat.yMd()
                                                    .format(selectedDate)) ||
                                            (todosnapshot
                                                    .data?.docs[index]['repeat']
                                                    .toString() ==
                                                "Daily")
                                        ? TodoCard(
                                            title: todosnapshot
                                                .data?.docs[index]['title'],
                                            icon: icondata,
                                            iconcolor: iconcolor,
                                            iconBgcolor: Colors.white,
                                            check: _selected[index].checkval,
                                            starttime: todosnapshot.data
                                                ?.docs[index]['start-time'],
                                            endtime: todosnapshot
                                                .data?.docs[index]['end-time'],
                                            index: index,
                                            onchnage: onchange,
                                          )
                                        : Container(),
                                  ),
                                )),
                          );
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void onchange(int index) {
    setState(() {
      _selected[index].checkval = !_selected[index].checkval;
      check = _selected[index].checkval;
    });
  }

  Future<void> deleteTasks(List<Select> selectedTasks, String userId) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final selectedTask in selectedTasks) {
      final taskRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("TaskDetails")
          .doc(selectedTask.id);

      batch.delete(taskRef);
    }

    await batch.commit();
  }

  Widget bottomnavigationbar(BuildContext context) {
    return BottomNavigationBar(backgroundColor: Colors.black87, items: [
      const BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          )),
      BottomNavigationBarItem(
          label: "",
          icon: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Colors.indigoAccent, Colors.purple])),
            child: IconButton(
              icon: const Icon(Icons.add, size: 30),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTodo(
                              date: selectedDate,
                            )));
              },
              color: Colors.white,
            ),
          )),
      BottomNavigationBarItem(
        label: "",
        icon: check == true
            ? IconButton(
                onPressed: () {
                  print(user!.email);
                  deleteTasks(_selected, user!.uid);

                  // Clear the selected tasks list
                  _selected.clear();
                },
                icon: const Icon(Icons.delete, color: Colors.white, size: 26))
            : const Icon(
                Icons.settings,
                size: 30,
                color: Colors.white,
              ),
      ),
    ]);
  }
}

Future<String> getuserName(User currentUser) async {
  if (currentUser != null) {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String username = userData['username'];
      return username;
    } else {
      return 'User document does not exist';
    }
  } else {
    return '';
  }
}

Widget drawer(BuildContext context, User user) {
  return FutureBuilder<String>(
    future: getuserName(user),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // Show a loading indicator while fetching data
      } else if (snapshot.hasError) {
        return const Text(
            'Error retrieving user data'); // Show an error message if there was an error
      } else {
        String? username = snapshot.data;
        return Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 640,
            child: Drawer(
              width: 200,
              backgroundColor: const Color(0xff2a2e3d),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32)),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          visualDensity: VisualDensity.standard,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      username ?? 'No username',
                      style: const TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 5),
                    child: Text(
                      user.email.toString(),
                      style: const TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF7F50)),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    },
  );
}

class Select {
  String id;
  bool checkval = false;
  Select({required this.id, required this.checkval});
}
