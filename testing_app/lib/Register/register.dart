import 'package:flutter/material.dart';
import 'package:testing_app/Register/Servers.dart';
import '/User_profile/Models.dart';
import '/first_page.dart';

List<String> courses = ["B.Tech", "M.Tech", "PG", "Phd", "MBA"];
List<String> branches = [
  "CS",
  "EC",
  "EE",
  "ME",
  "CE",
  "CH",
  "BT",
  "AR",
  "MT",
  "EP",
  "PE",
  "Other"
];
List<int> years = [0, 1, 2, 3, 4, 5, 6, 7, 8];

class LoginRegister extends StatefulWidget {
  Username app_user;
  LoginRegister(this.app_user);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  var course = "B.Tech";
  var branch = "CS";
  var year = 1;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //File(widget.app_user.profilePic!);
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
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Edit Your Profile",
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
                            initialValue: widget.app_user.username,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'username',
                              hintText: widget.app_user.username,
                              prefixIcon: Icon(Icons.text_fields),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.app_user.username = value;
                              });
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter email'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                            value: course,
                            underline: Container(),
                            elevation: 0,
                            items: courses
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                course = value!;
                              });
                            }),
                        const SizedBox(height: 10),
                        DropdownButton<int>(
                            value: year,
                            underline: Container(),
                            elevation: 0,
                            items:
                                years.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                year = value!;
                              });
                            }),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                            value: branch,
                            underline: Container(),
                            elevation: 0,
                            items: branches
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                branch = value!;
                              });
                            }),
                        const SizedBox(height: 10),
                        (widget.app_user.username != "")
                            ? Container(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                margin: EdgeInsets.only(top: 40),
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
                                              contentPadding:
                                                  EdgeInsets.all(15),
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

                                    bool error = await register_servers()
                                        .updating_required_user_details(
                                            widget.app_user.email!,
                                            course,
                                            year,
                                            branch);
                                    Navigator.pop(context);
                                    if (!error) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return get_ueser_widget(0);
                                      }), (Route<dynamic> route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Failed",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  color: Colors.indigo[200],
                                  textColor: Colors.black,
                                  child: const Text(
                                    "Update",
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
                                        content: Text(
                                          "Username and phone number cant be null",
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
          ),
        ));
  }
}
