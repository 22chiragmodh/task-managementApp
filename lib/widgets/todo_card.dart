import 'package:flutter/material.dart';

class TodoCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconcolor;
  final String time;
  final bool check;
  final Color iconBgcolor;
  final Function onchnage;
  final int index;
  const TodoCard(
      {required this.title,
      required this.icon,
      required this.time,
      required this.check,
      required this.onchnage,
      required this.index,
      required this.iconBgcolor,
      required this.iconcolor,
      super.key});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
              data: ThemeData(
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: const Color(0xff5e616a)),
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    activeColor: const Color(0xff6cf8a9),
                    checkColor: const Color(0xff0e3e26),
                    value: widget.check,
                    onChanged: (value) {
                      widget.onchnage(widget.index);
                    }),
              )),
          Expanded(
            child: SizedBox(
                height: 65,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: const Color(0xff2a2e3d),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          height: 30,
                          width: 33,
                          decoration: BoxDecoration(
                              color: widget.iconBgcolor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(widget.icon, color: widget.iconcolor),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(widget.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text(widget.time,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ))),
          )
        ],
      ),
    );
  }
}
