import 'package:flutter/material.dart';
import '/Timings/Servers.dart';
import '/User_profile/Models.dart';
import '/First_page.dart';

class academic_create extends StatefulWidget {
  int id;
  Username app_user;
  var academic_name;
  var sun;
  var mon;
  var tues;
  var wed;
  var thu;
  var fri;
  var sat;
  academic_create(this.id, this.app_user, this.academic_name, this.sun,
      this.mon, this.tues, this.wed, this.thu, this.fri, this.sat);

  @override
  State<academic_create> createState() => _academic_createState();
}

class _academic_createState extends State<academic_create> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: Text(
            widget.app_user.username!,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: Container(
          //color: Colors.pink[100],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Upload Academic details",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.academic_name,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'academic_name',
                            hintText: 'swimming pool',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.academic_name = value;
                              if (widget.academic_name == "") {
                                widget.academic_name = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.sun,
                          keyboardType: TextInputType.emailAddress,
                          //maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'SUN',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.sun = value;
                              if (widget.sun == "") {
                                widget.sun = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.mon,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'MON',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.mon = value;
                              if (widget.mon == "") {
                                widget.mon = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.tues,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'TUE',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.tues = value;
                              if (widget.tues == "") {
                                widget.tues = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.wed,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'WED',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.wed = value;
                              if (widget.wed == "") {
                                widget.wed = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.thu,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'THU',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.thu = value;
                              if (widget.thu == "") {
                                widget.thu = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.fri,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'FRI',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.fri = value;
                              if (widget.fri == "") {
                                widget.fri = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.sat,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'SAT',
                            hintText: '8AM - 9PM',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.sat = value;
                              if (widget.sat == "") {
                                widget.sat = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      (widget.academic_name != null &&
                              widget.sun != null &&
                              widget.mon != null &&
                              widget.tues != null &&
                              widget.wed != null &&
                              widget.thu != null &&
                              widget.fri != null &&
                              widget.sat != null)
                          ? Container(
                              padding: EdgeInsets.only(left: 40, right: 40),
                              margin: EdgeInsets.only(top: 8),
                              width: 270,
                              height: 60,
                              child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                minWidth: double.infinity,
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                            contentPadding: EdgeInsets.all(15),
                                            content: Container(
                                              margin: EdgeInsets.all(10),
                                              child: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "Please wait while uploading....."),
                                                    SizedBox(height: 10),
                                                    CircularProgressIndicator()
                                                  ]),
                                            ));
                                      });
                                  bool error = await timings_servers()
                                      .post_academic_list(
                                          widget.id,
                                          widget.app_user.domain!,
                                          widget.academic_name,
                                          widget.sun,
                                          widget.mon,
                                          widget.tues,
                                          widget.wed,
                                          widget.thu,
                                          widget.fri,
                                          widget.sat);

                                  Navigator.pop(context);
                                  if (!error) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return firstpage(0, widget.app_user);
                                    }), (Route<dynamic> route) => false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          "Failed",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                color: Colors.indigo[200],
                                textColor: Colors.black,
                                child: const Text(
                                  "Upload",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))
                          : Container(
                              margin: EdgeInsets.only(top: 40),
                              padding: EdgeInsets.only(left: 40, right: 40),
                              width: 250,
                              height: 55,
                              child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                minWidth: double.infinity,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 400),
                                      content: Text(
                                        "Anything cant be null",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                                color: Colors.green[200],
                                textColor: Colors.white,
                                child: const Text("Upload",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              )),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
