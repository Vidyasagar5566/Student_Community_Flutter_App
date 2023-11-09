import 'package:flutter/material.dart';
import '/Calender/Calender.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/Activities/Activities.dart';
import 'dart:io';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '/circular_designs/cure_clip.dart';
import '../App_notifications/Remainder_nitifications.dart';
import '/Activities/Models.dart';

class calender_events_display extends StatefulWidget {
  Username app_user;
  List<CALENDER_EVENT> cal_event_data;
  List<EVENT_LIST> activity_data;
  String date;

  calender_events_display(
      this.app_user, this.cal_event_data, this.activity_data, this.date);

  @override
  State<calender_events_display> createState() =>
      _calender_events_displayState();
}

class _calender_events_displayState extends State<calender_events_display> {
  int index = 0;
  bool sending_cmnt = false;
  var title;
  var description;
  List<bool> _extand = [];
  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    for (int i = 0; i < widget.cal_event_data.length; i++) {
      _extand.add(false);
    }
    return Scaffold(
        body: index == 0
            ? SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height + 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/background.jpg"),
                          fit: BoxFit.cover)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipPath(
                                clipper: profile_Clipper(),
                                child: Container(
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple,
                                      Colors.purple.shade300
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 80),
                                      SizedBox(
                                        width: wid / 2,
                                        child: Text(
                                          widget.date + " Tasks",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 25,
                                top: 75,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ))
                          ],
                        ),
                        widget.cal_event_data.isEmpty
                            ? Container(
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    padding: const EdgeInsets.all(20),
                                    child: const Text("No Tasks Today",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24)),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: ListView.builder(
                                    itemCount: widget.cal_event_data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      CALENDER_EVENT cal_event =
                                          widget.cal_event_data[index];
                                      return _buildLoadingScreen(cal_event,
                                          widget.cal_event_data, index);
                                    }),
                              )
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.keyboard_arrow_left,
                                    color: Colors.blue, size: 40)),
                            Container()
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      activitieswidget1(widget.activity_data, widget.app_user,
                          widget.app_user.domain!, true)
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          backgroundColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                label: "events",
                icon: Icon(
                  Icons.event_sharp,
                )),
            BottomNavigationBarItem(
                label: "activities",
                icon: Icon(
                  Icons.local_activity_outlined,
                )),
          ],
          currentIndex: index,
          onTap: (int index1) {
            setState(() {
              index = index1;
            });
          },
        ),
        floatingActionButton: index == 1
            ? Container()
            : ElevatedButton.icon(
                onPressed: () {
                  String formattedTime = "12:00";
                  TextEditingController timeinput = TextEditingController();
                  timeinput.text = "12:00:00";
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.all(15),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          labelText: 'title',
                                          hintText: 'Maths Assignment',
                                          prefixIcon: Icon(Icons.text_fields),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      onChanged: (String value) {
                                        setState(() {
                                          title = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      minLines:
                                          4, //Normal textInputField will be displayed
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                          labelText: 'Description',
                                          hintText:
                                              'i have to complete it by today n8....',
                                          prefixIcon: Icon(Icons.text_fields),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      onChanged: (String value) {
                                        setState(() {
                                          description = value;
                                          if (description == "") {
                                            description = null;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 40),
                                      child: TextField(
                                        //                                 initialValue: "12:00:00",
                                        controller:
                                            timeinput, //editing controller of this TextField
                                        decoration: const InputDecoration(
                                            labelText: "Enter Time",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        10))) //label text of field
                                            ),
                                        readOnly:
                                            true, //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            context: context,
                                          );
                                          formattedTime =
                                              pickedTime!.hour.toString() +
                                                  ":" +
                                                  pickedTime.minute.toString() +
                                                  ':00';
                                          setState(() {
                                            timeinput.text = formattedTime;
                                          });
                                        },
                                      )),
                                  const SizedBox(height: 10),
                                  TextButton(
                                      onPressed: () async {
                                        if (widget.app_user.email ==
                                            "guest@nitc.ac.in") {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                "Guests are not allowed",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (title == null ||
                                              description == null) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                content: Text(
                                                  "title or description cant be null",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            CALENDER_EVENT a = CALENDER_EVENT();
                                            a.username =
                                                user_min(widget.app_user);
                                            a.title = title;
                                            a.description = description;
                                            a.insertMessage = true;
                                            a.messageSent = false;
                                            a.fileType = '0';
                                            a.eventDate = widget.date +
                                                'T' +
                                                formattedTime;

                                            File temp_image =
                                                File('images/profile.jpg');
                                            List<dynamic> error =
                                                await calendar_servers()
                                                    .post_calender_event(
                                                        "self",
                                                        title,
                                                        description,
                                                        temp_image,
                                                        '0',
                                                        '0000',
                                                        '@',
                                                        'All',
                                                        widget.date +
                                                            'T' +
                                                            formattedTime);
                                            setState(() {
                                              if (!error[0]) {
                                                widget.cal_event_data.add(a);
                                                all_dates.add(widget.date +
                                                    ' ' +
                                                    formattedTime +
                                                    '&&' +
                                                    title);
                                                a.id = error[1];
                                                a.messageSent = true;
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    content: Text(
                                                      "error occured try again",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                          }
                                        }
                                      },
                                      child: const Center(
                                        child: Text("Add"),
                                      ))
                                ]));
                      });
                },
                label: const Text("Add new Task",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.edit, color: Colors.white),
                style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              ));
  }

  Widget _buildLoadingScreen(CALENDER_EVENT cal_event,
      List<CALENDER_EVENT> cal_event_data, int index) {
    var wid = MediaQuery.of(context).size.width;
    var hig = MediaQuery.of(context).size.height;
    return Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        width: wid,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text(cal_event.title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white)),
                    ),
                    cal_event.messageSent == false
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : !_extand[index]
                            ? IconButton(
                                onPressed: () {
                                  for (int i = 0; i < _extand.length; i++) {
                                    setState(() {
                                      _extand[index] = false;
                                    });
                                  }
                                  setState(() {
                                    _extand[index] = !_extand[index];
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down, //delete_forever,
                                  size: 31,
                                  color: Colors.white,
                                ))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _extand[index] = !_extand[index];
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_up, //delete_forever,
                                  size: 31,
                                  color: Colors.white,
                                ))
                  ],
                ),
              ],
            )),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: wid - 100),
                  child: Text(
                    cal_event.insertMessage!
                        ? cal_event.description!
                        : utf8convert(cal_event.description!),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container()
              ],
            ),
            const SizedBox(height: 5),
            cal_event.fileType != '0'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (cal_event.fileType == '1') {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Scaffold(
                                    appBar: AppBar(
                                      leading: const BackButton(
                                        color: Colors.white, // <-- SEE HERE
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                    body: Container(
                                      height: hig,
                                      width: wid,
                                      color: Colors.black,
                                      child: Center(
                                          child: Image(
                                              image: NetworkImage(cal_event
                                                  .calenderDateFile!))),
                                    ));
                              }));
                            } else if (cal_event.fileType == '2') {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return video_display(cal_event);
                              }));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return pdfviewer1(
                                    cal_event.calenderDateFile!, true);
                              }));
                            }
                          },
                          child: const Center(
                            child: Text("View file"),
                          )),
                      Container()
                    ],
                  )
                : Container(),
            _extand[index]
                ? Column(children: [
                    widget.app_user.email == cal_event.username!.email
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Container(
                                  child: const Text("Delete task?"),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      bool error = await calendar_servers()
                                          .delete_calender_event(cal_event.id!);
                                      if (!error) {
                                        setState(() {
                                          cal_event_data.remove(cal_event);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ))
                              ])
                        : Container(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: const Text("Add remainder?"),
                          ),
                          IconButton(
                              onPressed: () async {
                                var cur_date_time =
                                    cal_event.eventDate!.split("T");
                                var cur_date = cur_date_time[0].split("-");
                                var cur_time = cur_date_time[1].split(":");

                                try {
                                  await NotificationService()
                                      .scheduleNotification(
                                          id: cal_event.id!,
                                          title: cal_event.title!,
                                          body: cal_event.description!,
                                          scheduledNotificationDateTime:
                                              DateTime(
                                                  int.parse(cur_date[0]),
                                                  int.parse(cur_date[1]),
                                                  int.parse(cur_date[2]),
                                                  int.parse(cur_time[0]),
                                                  int.parse(cur_time[1]),
                                                  int.parse(cur_time[2])));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(milliseconds: 400),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'remainder added successfully',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                await NotificationService()
                                                    .notificationsPlugin
                                                    .cancel(cal_event.id!);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    content: Text(
                                                      'undo successfully.',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                "undo?",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 400),
                                      content: Text(
                                        'already added',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.alarm,
                                color: Colors.white,
                              ))
                        ]),
                    widget.app_user.email == cal_event.username!.email
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Container(
                                  child: const Text("Edit task?"),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      title = cal_event.title;
                                      description = cal_event.description;

                                      String formattedTime = "12:00";
                                      TextEditingController timeinput =
                                          TextEditingController();
                                      timeinput.text =
                                          cal_event.eventDate!.split('T')[1];
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close))
                                                        ],
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 40,
                                                                right: 40),
                                                        child: TextFormField(
                                                          initialValue:
                                                              cal_event.title,
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          decoration: const InputDecoration(
                                                              labelText:
                                                                  'title',
                                                              hintText:
                                                                  'Maths Assignment',
                                                              prefixIcon: Icon(Icons
                                                                  .text_fields),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)))),
                                                          onChanged:
                                                              (String value) {
                                                            setState(() {
                                                              cal_event.title =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 40,
                                                                right: 40),
                                                        child: TextFormField(
                                                          initialValue:
                                                              cal_event
                                                                  .description,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          minLines:
                                                              4, //Normal textInputField will be displayed
                                                          maxLines: 10,
                                                          decoration: const InputDecoration(
                                                              labelText:
                                                                  'Description',
                                                              hintText:
                                                                  'i have to complete it by today n8....',
                                                              prefixIcon: Icon(Icons
                                                                  .text_fields),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)))),
                                                          onChanged:
                                                              (String value) {
                                                            setState(() {
                                                              description =
                                                                  value;
                                                              if (description ==
                                                                  "") {
                                                                cal_event
                                                                        .description =
                                                                    null;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 40,
                                                                  right: 40),
                                                          child: TextFormField(
                                                            //                                 initialValue: "12:00:00",
                                                            controller:
                                                                timeinput, //editing controller of this TextField
                                                            decoration: const InputDecoration(
                                                                labelText:
                                                                    "Enter Time",
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))) //label text of field
                                                                ),
                                                            readOnly:
                                                                true, //set it true, so that user will not able to edit text
                                                            onTap: () async {
                                                              TimeOfDay?
                                                                  pickedTime =
                                                                  await showTimePicker(
                                                                initialTime:
                                                                    TimeOfDay
                                                                        .now(),
                                                                context:
                                                                    context,
                                                              );
                                                              formattedTime = pickedTime!
                                                                      .hour
                                                                      .toString() +
                                                                  ":" +
                                                                  pickedTime
                                                                      .minute
                                                                      .toString() +
                                                                  ':00';
                                                              setState(() {
                                                                timeinput.text =
                                                                    formattedTime;
                                                              });
                                                            },
                                                          )),
                                                      const SizedBox(
                                                          height: 10),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (widget.app_user
                                                                    .email ==
                                                                "guest@nitc.ac.in") {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          400),
                                                                  content: Text(
                                                                    "Guests are not allowed",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              if (title ==
                                                                      null ||
                                                                  description ==
                                                                      null) {
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    content:
                                                                        Text(
                                                                      "title or description cant be null",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                cal_event
                                                                        .title =
                                                                    title;
                                                                cal_event
                                                                        .description =
                                                                    description;
                                                                cal_event
                                                                        .insertMessage =
                                                                    true;
                                                                cal_event
                                                                        .messageSent =
                                                                    false;
                                                                cal_event
                                                                        .fileType =
                                                                    '0';
                                                                cal_event
                                                                    .eventDate = widget
                                                                        .date +
                                                                    'T' +
                                                                    formattedTime;

                                                                File
                                                                    temp_image =
                                                                    File(
                                                                        'images/profile.jpg');
                                                                List<dynamic> error = await calendar_servers().edit_calender_event(
                                                                    cal_event
                                                                        .id!,
                                                                    "self",
                                                                    title,
                                                                    description,
                                                                    temp_image,
                                                                    '0',
                                                                    '0000',
                                                                    '@',
                                                                    widget.date +
                                                                        'T' +
                                                                        formattedTime);
                                                                setState(() {
                                                                  if (!error[
                                                                      0]) {
                                                                    cal_event
                                                                            .messageSent =
                                                                        true;
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 400),
                                                                        content:
                                                                            Text(
                                                                          "error occured try again",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: const Center(
                                                            child:
                                                                Text("Update"),
                                                          ))
                                                    ]));
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ))
                              ])
                        : Container()
                  ])
                : Container(),
          ],
        ));
  }
}

class video_display extends StatefulWidget {
  CALENDER_EVENT cal_event;
  video_display(this.cal_event);

  @override
  State<video_display> createState() => _video_displayState();
}

class _video_displayState extends State<video_display> {
  VideoPlayerController? _videoPlayerController;
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _videoPlayerController = VideoPlayerController.network(
        widget.cal_event.calenderDateFile!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          actions: [
            !widget.cal_event.insertMessage!
                ? Container(
                    child: (ret == "" || ret == "failed")
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                ret = "start";
                              });
                              bool _permissionReady = await _checkPermission();
                              if (_permissionReady) {
                                await _prepareSaveDir();
                                print("Downloading");
                                try {
                                  List<String> urls = widget
                                      .cal_event.calenderDateFile!
                                      .split('?');
                                  List<String> sub_urls = urls[0].split("/");
                                  await Dio().download(
                                      widget.cal_event.calenderDateFile!,
                                      _localPath +
                                          sub_urls[sub_urls.length - 1]);
                                  setState(() {
                                    ret = "";
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 400),
                                      content: Text(
                                        'success',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() {
                                    ret = "failed";
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 400),
                                      content: Text(
                                        'failed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.download_rounded,
                                color: Colors.white),
                          )
                        : const SizedBox(
                            height: 12,
                            width: 12,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                  )
                : Container()
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_videoPlayerController!),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              _videoPlayerController!.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                _videoPlayerController!.value.isPlaying
                                    ? _videoPlayerController!.pause()
                                    : _videoPlayerController!.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      _videoPlayerController!,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      _videoPlayerController!.pause();
      _showController = !_showController;
    });
  }
}
