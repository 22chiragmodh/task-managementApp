import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTodo extends StatefulWidget {
  DateTime date;
  AddTodo({super.key, required this.date});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String selectCatagory = "Other";
  String? selectedDate;
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = "11:30 PM";
  int selectRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 30];
  String selectRepeat = "None";
  List<String> repeatList = ["Daily", "Weekly", "Monthly", "None"];
  List<String> categoryList = [
    "Workout",
    "Urgent",
    "Sports",
    "HomeWork",
    "Meeting",
    "Development",
    "Design",
    "Gym",
    "Eating",
    "Market",
    "Learning",
    "Dance",
    "Music",
    "Other"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ])),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.keyboard_arrow_left,
                                color: Colors.white, size: 30)),
                        const SizedBox(width: 80),
                        const Text(
                          "Add Task",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          label("Title"),
                          const SizedBox(height: 12),
                          labelinputfield(context, "Enter title here."),
                          const SizedBox(
                            height: 15,
                          ),
                          label("Description"),
                          const SizedBox(height: 12),
                          descriptionfield(context),
                          const SizedBox(
                            height: 15,
                          ),
                          label("Date"),
                          const SizedBox(height: 12),
                          dateinputfield(
                              context,
                              DateFormat.yMd().format(widget.date).toString(),
                              IconButton(
                                  onPressed: getDatefromUser,
                                  icon: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.white54,
                                  )),
                              MediaQuery.of(context).size.width),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    label("Start Time"),
                                    const SizedBox(height: 12),
                                    dateinputfield(
                                        context,
                                        startTime,
                                        IconButton(
                                            onPressed: () async {
                                              final pickedTime =
                                                  await getTimeFromUser(
                                                      isStartTime: true);
                                              if (pickedTime != null) {
                                                onTimeSelected(
                                                    pickedTime, true);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.white54,
                                            )),
                                        MediaQuery.of(context).size.width *
                                            0.41),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    label("End Time"),
                                    const SizedBox(height: 12),
                                    dateinputfield(
                                        context,
                                        endTime,
                                        IconButton(
                                            onPressed: () async {
                                              final pickedTime =
                                                  await getTimeFromUser(
                                                      isStartTime: false);
                                              if (pickedTime != null) {
                                                onTimeSelected(
                                                    pickedTime, false);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.white54,
                                            )),
                                        MediaQuery.of(context).size.width *
                                            0.41),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          label("Remind"),
                          const SizedBox(height: 12),
                          dateinputfield(
                              context,
                              "$selectRemind minutes early",
                              DropdownButton(
                                underline: Container(height: 0),
                                items: remindList
                                    .map<DropdownMenuItem<String>>((int value) {
                                  return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value.toString()));
                                }).toList(),
                                onChanged: (String? val) {
                                  setState(() {
                                    selectRemind = int.parse(val!);
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white54,
                                ),
                                iconSize: 32,
                                elevation: 4,
                              ),
                              MediaQuery.of(context).size.width),
                          const SizedBox(
                            height: 15,
                          ),
                          label("Repeat"),
                          const SizedBox(height: 12),
                          dateinputfield(
                              context,
                              selectRepeat,
                              DropdownButton(
                                underline: Container(height: 0),
                                items: repeatList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (String? val) {
                                  setState(() {
                                    selectRepeat = val!;
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white54,
                                ),
                                iconSize: 32,
                                elevation: 4,
                              ),
                              MediaQuery.of(context).size.width),
                          const SizedBox(height: 12),
                          label("Category"),
                          const SizedBox(height: 12),
                          // Wrap(
                          //   runSpacing: 8,
                          //   children: [
                          //     taskcatagory("Workout", 0xff234ebd),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Meeting", 0xff2bc8d9),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Urgent", 0xffff6d6e),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Developement", 0xff467892),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Design", 0xffFFBF00),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Food", 0xff008080),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Study", 0xffFF7F50),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     taskcatagory("Sports", 0xff6557ff),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //   ],
                          // ),
                          dateinputfield(
                              context,
                              selectCatagory,
                              DropdownButton(
                                underline: Container(height: 0),
                                items: categoryList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (String? val) {
                                  setState(() {
                                    selectCatagory = val!;
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white54,
                                ),
                                iconSize: 32,
                                elevation: 4,
                              ),
                              MediaQuery.of(context).size.width),
                          const SizedBox(height: 20),
                          button(context),
                          const SizedBox(height: 30),
                        ],
                      )),
                ],
              ),
            )));
  }

  Widget labelinputfield(BuildContext context, String? hinttext) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: titlecontroller,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              border: InputBorder.none,
              hintText: hinttext!,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15)),
        ));
  }

  Widget dateinputfield(
      BuildContext context, String hintText, Widget? datePicker, double width) {
    return Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: datePicker == null ? false : true,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            ),
            datePicker!
          ],
        ));
  }

  getDatefromUser() async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2001),
        lastDate: DateTime(2065));

    if (pickDate != null) {
      setState(() {
        widget.date = pickDate;
        selectedDate = DateFormat.yMd().format(pickDate);
      });
    }
  }

  // getTimefromUser({required bool isStartTime}) async {
  //   var pickTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay(
  //           hour: int.parse(startTime.split(":")[0]),
  //           minute: int.parse(startTime.split(":")[1].split(" ")[0])),
  //       initialEntryMode: TimePickerEntryMode.input);

  //   if (pickTime != null) {
  //     String formateTime = pickTime.format(context);
  //     if (isStartTime) {
  //       setState(() {
  //         startTime = formateTime;
  //       });
  //     } else if (!isStartTime) {
  //       setState(() {
  //         endTime = formateTime;
  //       });
  //     }
  //   } else if (pickTime == null) {
  //     print("Time cancelled");
  //   }
  // }

  Future<TimeOfDay?> getTimeFromUser({required bool isStartTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
    );

    return pickedTime;
  }

  void onTimeSelected(TimeOfDay pickedTime, bool isStartTime) {
    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          startTime = formattedTime;
        });
      } else {
        setState(() {
          endTime = formattedTime;
        });
      }
    }
  }

  Widget descriptionfield(BuildContext context) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: descriptioncontroller,
          maxLines: null,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              border: InputBorder.none,
              hintText: "Enter description here....",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
        ));
  }

  // Widget taskcatagory(String taskcatagory, int color) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         catagory = taskcatagory;
  //       });
  //     },
  //     child: Chip(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       backgroundColor: catagory == taskcatagory ? Colors.white : Color(color),
  //       labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
  //       label: Text(taskcatagory,
  //           style: TextStyle(
  //               color: catagory == taskcatagory ? Colors.black : Colors.white,
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600)),
  //     ),
  //   );
  // }

  Widget button(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    DateTime now = DateTime.now();
    String datetime = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .collection("TaskDetails")
            .add({
          "title": titlecontroller.text,
          "date-time": datetime,
          "description": descriptioncontroller.text,
          "selectedDate": selectedDate,
          "start-time": startTime,
          "end-time": endTime,
          "repeat": selectRepeat,
          "catagory": selectCatagory,
        });

        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                colors: [Color(0xff000080), Color(0xff800080)])),
        child: const Center(
          child: Text("Add Todo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

Widget label(String title) {
  return Text(title,
      style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.3));
}
