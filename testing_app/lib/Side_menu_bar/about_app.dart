import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import '/User_profile/Models.dart';
import '/Reports/Servers.dart';

class about_app extends StatefulWidget {
  Username app_user;
  about_app(this.app_user);

  @override
  State<about_app> createState() => _about_appState();
}

class _about_appState extends State<about_app> {
  var report;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "Help Center",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: Container(
          margin: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 6),
              const Text(
                  "Welcome to our ESMUS-app Help Center!. If you encounter any issues or have questions while using the app, don't hesitate to reach out to us."),
              SizedBox(height: 18),
              const Text("Empower Your University Experience : ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableLinkify(
                      text:
                          '''Unlock a world of opportunities by joining university clubs, sports, and fests through our app! For those seeking admin permissions to make our app the official communication channel within your university'''),
                  const SizedBox(height: 7),
                  SelectableLinkify(
                      text:
                          "we're here to help. Connect with us via email at studentcommunity.iit.nit@gmail.com or reach out to us by phone at 8310045115. Elevate your university experience with seamless communication, vibrant communities, and official integration"),
                  const SizedBox(height: 7),
                  Text("Let's make university life extraordinary together!")
                ],
              ),
              SizedBox(height: 18),
              const Text("Report/suggestions:",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              const Text(
                  "feel free to share your valuable thoughts(Report/suggestions/feedback) to understand more about student requirements."),
              const SizedBox(height: 8),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextField(
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: '',
                    hintText: widget.app_user.username,
                    prefixIcon: Icon(Icons.text_fields),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      if (value == "") {
                        report = null;
                      } else {
                        report = value;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              (report != null)
                  ? Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      margin: EdgeInsets.only(top: 40),
                      width: 270,
                      height: 60,
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        minWidth: double.infinity,
                        onPressed: () async {
                          if (widget.app_user.email!.split('@')[0] == "guest") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(milliseconds: 400),
                                    content: Text(
                                        "guest cannot share any feedback/etc..",
                                        style:
                                            TextStyle(color: Colors.white))));
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      contentPadding: EdgeInsets.all(15),
                                      content: Container(
                                        margin: EdgeInsets.all(10),
                                        child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Please wait while uploading....."),
                                              SizedBox(height: 10),
                                              CircularProgressIndicator()
                                            ]),
                                      ));
                                });
                            List<dynamic> error = await report_servers()
                                .report_upload(report, "student");
                            Navigator.pop(context);
                            if (!error[0]) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Column(
                                    children: [
                                      const Text(
                                        "We will look into it with in 24 hours",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      content: Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: const Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  "Please wait while removing....."),
                                                              SizedBox(
                                                                  height: 10),
                                                              CircularProgressIndicator()
                                                            ]),
                                                      ));
                                                });
                                            bool error1 = await report_servers()
                                                .report_delete(error[1]);
                                            Navigator.pop(context);
                                            if (!error1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                "undo successfully",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                "error occured!, dont worry no problem of submitting wrong contents,",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )));
                                            }
                                          },
                                          child: const Text(
                                            "Undo",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 400),
                                  content: Text(
                                    "error occured, please try again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        color: Colors.indigo[200],
                        textColor: Colors.black,
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ))
                  : Container(
                      margin: EdgeInsets.only(top: 40),
                      padding: EdgeInsets.only(left: 40, right: 40),
                      width: 250,
                      height: 55,
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        minWidth: double.infinity,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 400),
                              content: Text(
                                "empty text cant be report,",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        color: Colors.green[200],
                        textColor: Colors.white,
                        child: const Text("Submit",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      )),
              const SizedBox(height: 10),
              Text("",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.2))),
              Text(
                "Developer details",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text("B.R Vidya Sagar",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.2),
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text("Alumin of Nit Calicut(2019 - 2023)",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.2),
                      fontStyle: FontStyle.italic)),
            ]),
          ),
        ));
  }
}
