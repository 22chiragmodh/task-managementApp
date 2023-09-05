import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditTodo extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  DateTime date;
  final User? user;
  EditTodo(
      {required this.data,
      required this.id,
      super.key,
      required this.date,
      required this.user});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController? titlecontroller;
  TextEditingController? descriptioncontroller;
  String selectCatagory = "";
  String? selectedDate;
  String startTime = "";
  String endTime = "";
  int? selectRemind;
  List<int> remindList = [5, 10, 15, 20, 30];
  String selectRepeat = "";
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
  bool edit = false;
  @override
  void initState() {
    super.initState();

    titlecontroller = TextEditingController(text: widget.data['title']);
    descriptioncontroller =
        TextEditingController(text: widget.data['description']);
    selectCatagory = widget.data['catagory'];
    selectedDate = widget.data['selectedDate'];
    startTime = widget.data['start-time'];
    endTime = widget.data['end-time'];
    selectRepeat = widget.data['repeat'];
  }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 25)),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  edit = !edit;
                                });
                              },
                              icon: Icon(Icons.edit,
                                  color:
                                      edit == true ? Colors.red : Colors.green,
                                  size: 25)),
                          IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.user?.uid)
                                    .collection("TaskDetails")
                                    .doc(widget.id)
                                    .delete()
                                    .then((value) => {
                                          Navigator.pop(context),
                                        });
                              },
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 25)),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edit == true ? "Editing" : "View",
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Your Todo",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          label("Task Title"),
                          const SizedBox(height: 12),
                          labelinputfield(context),
                          const SizedBox(
                            height: 25,
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
                                  onPressed: edit ? getDatefromUser : () {},
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
                                            onPressed: edit
                                                ? () async {
                                                    final pickedTime =
                                                        await getTimeFromUser(
                                                            isStartTime: true);
                                                    if (pickedTime != null) {
                                                      onTimeSelected(
                                                          pickedTime, true);
                                                    }
                                                  }
                                                : () {},
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
                                            onPressed: edit
                                                ? () async {
                                                    final pickedTime =
                                                        await getTimeFromUser(
                                                            isStartTime: false);
                                                    if (pickedTime != null) {
                                                      onTimeSelected(
                                                          pickedTime, false);
                                                    }
                                                  }
                                                : () {},
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
                              edit
                                  ? DropdownButton(
                                      underline: Container(height: 0),
                                      items: remindList
                                          .map<DropdownMenuItem<String>>(
                                              (int value) {
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
                                    )
                                  : const SizedBox(),
                              MediaQuery.of(context).size.width),
                          const SizedBox(
                            height: 15,
                          ),
                          label("Repeat"),
                          const SizedBox(height: 12),
                          dateinputfield(
                              context,
                              selectRepeat,
                              edit
                                  ? DropdownButton(
                                      underline: Container(height: 0),
                                      items: repeatList
                                          .map<DropdownMenuItem<String>>(
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
                                    )
                                  : const SizedBox(),
                              MediaQuery.of(context).size.width),
                          const SizedBox(height: 12),
                          label("Category"),
                          const SizedBox(height: 12),
                          dateinputfield(
                              context,
                              selectCatagory,
                              edit
                                  ? DropdownButton(
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
                                    )
                                  : const SizedBox(),
                              MediaQuery.of(context).size.width),
                          const SizedBox(height: 20),
                          edit ? button(context) : Container(),
                          const SizedBox(height: 30),
                        ],
                      )),
                ],
              ),
            )));
  }

  Widget labelinputfield(BuildContext context) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          enabled: edit,
          controller: titlecontroller,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
        ));
  }

  Widget descriptionfield(BuildContext context) {
    return Container(
        height: 140,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          enabled: edit,
          controller: descriptioncontroller,
          maxLines: null,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              border: InputBorder.none,
              hintText: "Description",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
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
                enabled: edit,
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

  Widget button(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user?.uid)
            .collection("TaskDetails")
            .doc(widget.id)
            .update({
          "title": titlecontroller?.text,
          "description": descriptioncontroller?.text,
          "catagory": selectCatagory,
          "selectedDate": selectedDate,
          "start-time": startTime,
          "end-time": endTime,
          "repeat": selectRepeat,
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
          child: Text("Update Todo",
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
