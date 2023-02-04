import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String catagory = "";
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
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 25)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "New Task",
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
                          const SizedBox(height: 30),
                          label("Category"),
                          const SizedBox(height: 12),
                          Wrap(
                            runSpacing: 8,
                            children: [
                              taskcatagory("Workout", 0xff234ebd),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Meeting", 0xff2bc8d9),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Urgent", 0xffff6d6e),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Developement", 0xff467892),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Design", 0xffFFBF00),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Food", 0xff008080),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Study", 0xffFF7F50),
                              const SizedBox(
                                width: 20,
                              ),
                              taskcatagory("Sports", 0xff6557ff),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          button(context),
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

  Widget taskcatagory(String taskcatagory, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          catagory = taskcatagory;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: catagory == taskcatagory ? Colors.white : Color(color),
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
        label: Text(taskcatagory,
            style: TextStyle(
                color: catagory == taskcatagory ? Colors.black : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget button(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").add({
          "title": titlecontroller.text,
          "description": descriptioncontroller.text,
          "catagory": catagory
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
