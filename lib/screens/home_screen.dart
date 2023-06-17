import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_managementapp/screens/addtodo.dart';
import 'package:task_managementapp/screens/edittodo.dart';
import 'package:task_managementapp/widgets/todo_card.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Select> _selected = [];
  DateTime selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(context),
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
                  selectedDate = date;
                },
              )),
          const SizedBox(height: 5),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .collection("TaskDetails")
                    .snapshots(),
                builder: (context, todosnapshot) {
                  if (!todosnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: todosnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
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
                          case "Food":
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
                          default:
                            icondata = Icons.work_history;
                            iconcolor = Colors.black;
                        }

                        _selected.add(Select(
                            id: todosnapshot.data!.docs[index].id,
                            checkval: false));
                        return InkWell(
                          onTap: () {
                            print(todosnapshot.data!.docs[index].id);
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
                          child: TodoCard(
                            title: todosnapshot.data?.docs[index]['title'],
                            icon: icondata,
                            iconcolor: iconcolor,
                            iconBgcolor: Colors.white,
                            check: _selected[index].checkval,
                            starttime: todosnapshot.data?.docs[index]
                                ['start-time'],
                            endtime: todosnapshot.data?.docs[index]['end-time'],
                            index: index,
                            onchnage: onchange,
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  void onchange(int index) {
    setState(() {
      _selected[index].checkval = !_selected[index].checkval;
    });
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
              icon: Icon(Icons.add, size: 30),
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
      const BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          )),
    ]);
  }
}

Widget drawer(BuildContext context) {
  return Align(
    alignment: Alignment.topRight,
    child: SizedBox(
      height: 640,
      child: Drawer(
        width: 200,
        backgroundColor: const Color(0xff2a2e3d),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), bottomLeft: Radius.circular(32)),
        ),
        child: ListView(
          // Important: Remove any padding from the ListView.
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
            const SizedBox(
              height: 80,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF7F50)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text("Logout")),
            )
          ],
        ),
      ),
    ),
  );
}

class Select {
  String id;
  bool checkval = false;
  Select({required this.id, required this.checkval});
}
