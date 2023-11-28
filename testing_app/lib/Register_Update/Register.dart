import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Register_Update/Servers.dart';
import '/User_profile/Models.dart';
import '/First_page.dart';

List<String> courses = ["B.Tech", "M.Tech", "PG", "Phd", "MBA", "Other"];
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
List<int> years = [1, 2, 3, 4];
List<int> years1 = [1, 2];
List<int> years2 = [1, 2, 3, 4, 5, 6, 7, 8];

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
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    if (!widget.app_user.isDetails!) {
      Future.delayed(
          Duration.zero,
          () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                const Text(
                                  "Please Edit Your Profile",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: TextFormField(
                                          initialValue:
                                              widget.app_user.username,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: 'username',
                                            hintText: widget.app_user.username,
                                            prefixIcon: Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
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
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Course",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(width: 20),
                                              DropdownButton<String>(
                                                  value: course,
                                                  underline: Container(),
                                                  elevation: 0,
                                                  items: courses.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      course = value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Year",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(width: 20),
                                              DropdownButton<int>(
                                                  value: year,
                                                  underline: Container(),
                                                  elevation: 0,
                                                  items: (course == "B.Tech"
                                                          ? years
                                                          : course == "M.Tech"
                                                              ? years1
                                                              : course == "PG"
                                                                  ? years1
                                                                  : course ==
                                                                          "Phd"
                                                                      ? years2
                                                                      : course ==
                                                                              "MBA"
                                                                          ? years1
                                                                          : years2)
                                                      .map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child: Text(
                                                        value.toString(),
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      year = value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Branch",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(width: 20),
                                              DropdownButton<String>(
                                                  value: branch,
                                                  underline: Container(),
                                                  elevation: 0,
                                                  items: branches.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      branch = value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(height: 10),
                                      (widget.app_user.username != "")
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 40),
                                              margin: EdgeInsets.only(top: 40),
                                              width: 270,
                                              height: 60,
                                              child: MaterialButton(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                minWidth: double.infinity,
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            content: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: const Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                        "Please wait while uploading....."),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    CircularProgressIndicator()
                                                                  ]),
                                                            ));
                                                      });

                                                  bool error =
                                                      await register_servers()
                                                          .updating_required_user_details(
                                                              widget.app_user
                                                                  .email!,
                                                              widget.app_user
                                                                  .username!,
                                                              course,
                                                              year,
                                                              branch);
                                                  Navigator.pop(context);
                                                  if (!error) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                      return get_ueser_widget(
                                                          0);
                                                    }),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15),
                                                              content:
                                                                  Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
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
                                                                                icon: Icon(Icons.close))
                                                                          ]),
                                                                      Text(
                                                                          "Failed, May Be The Username Was Already Exits, Please Try Again With New User Name"),
                                                                    ]),
                                                              ));
                                                        });
                                                  }
                                                },
                                                color: Colors.indigo[200],
                                                textColor: Colors.black,
                                                child: const Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ))
                                          : Container(
                                              margin: EdgeInsets.only(top: 40),
                                              padding: EdgeInsets.only(
                                                  left: 40, right: 40),
                                              width: 250,
                                              height: 55,
                                              child: MaterialButton(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                minWidth: double.infinity,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Username and phone number cant be null",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                color: Colors.green[200],
                                                textColor: Colors.white,
                                                child: const Text("Upload",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ));
    }
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
        ));
  }
}

class appUpdate extends StatefulWidget {
  const appUpdate({super.key});

  @override
  State<appUpdate> createState() => _appUpdateState();
}

class _appUpdateState extends State<appUpdate> {
  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    Future.delayed(
        Duration.zero,
        () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: SingleChildScrollView(
                      child: Column(
                children: [
                  Container(
                    child: const Text(
                      "Please Update The App inorder to ligin",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: const Text(
                      "Playstore visit",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: SelectableLinkify(
                        onOpen: (url) async {
                          if (await canLaunch(url.url)) {
                            await launch(url.url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        text:
                            "https://play.google.com/store/apps/details?id=com.nitc.InstaBook&pcampaignid=web_share"),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: const Text(
                      "App Store visit",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: SelectableLinkify(
                        onOpen: (url) async {
                          if (await canLaunch(url.url)) {
                            await launch(url.url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        text:
                            "https://apps.apple.com/in/app/nitc-instabook/id6455889703"),
                  )
                ],
              )));
            }));
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("App UpdatebRequired!!"),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: const Center(
              child: Text(
                "Please Visit The Play Store and Update The App",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ));
  }
}
