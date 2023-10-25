import 'package:flutter/material.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'Servers.dart';

class report_upload extends StatefulWidget {
  Username app_user;
  String report_belongs;
  String email;
  report_upload(this.app_user, this.report_belongs, this.email);

  @override
  State<report_upload> createState() => _report_uploadState();
}

class _report_uploadState extends State<report_upload> {
  var description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Reports",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                  Center(
                    child: Text(
                      "Report the " + widget.report_belongs,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines:
                                4, //Normal textInputField will be displayed
                            maxLines: 10,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'This post is .....',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                description = value;
                                if (description == "") {
                                  description = null;
                                }
                              });
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter password'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        (description != null)
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
                                    if (widget.app_user.email ==
                                        "guest@nitc.ac.in") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "guest cannot report..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Text(
                                                            "Please wait while uploading....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      List<dynamic> error =
                                          await report_servers().report_upload(
                                              description,
                                              widget.report_belongs);
                                      Navigator.pop(context);
                                      if (!error[0]) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Column(
                                              children: [
                                                const Text(
                                                  "We will look into it with in 24 hours",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15),
                                                                content:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: const Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                            "Please wait while removing....."),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        CircularProgressIndicator()
                                                                      ]),
                                                                ));
                                                          });
                                                      bool error1 =
                                                          await report_servers()
                                                              .report_delete(
                                                                  error[1]);
                                                      Navigator.pop(context);
                                                      if (!error1) {
                                                        const SnackBar(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    400),
                                                            content: Text(
                                                              "undo successfully",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ));
                                                      } else {
                                                        const SnackBar(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    400),
                                                            content: Text(
                                                              "error occured!, dont worry no problem of submitting wrong contents,",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ));
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Undo",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration:
                                                Duration(milliseconds: 400),
                                            content: Text(
                                              "Failed to report try again",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
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
                                          "Fill all the details",
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
