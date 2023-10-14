import 'package:flutter/material.dart';
import 'Servers.dart';
import 'package:testing_app/User_profile/Models.dart';


class notif_settings extends StatefulWidget {
  Username app_user;
  notif_settings(this.app_user);

  @override
  State<notif_settings> createState() => _notif_settingsState();
}

class _notif_settingsState extends State<notif_settings> {
  bool int_bool(String num) {
    if (num == '0') {
      return false;
    } else {
      return true;
    }
  }

  String bool_int(bool val) {
    if (val == true) {
      return '1';
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    String notiffications = widget.app_user.notifSettings!;
    bool one = int_bool(notiffications[0]);
    bool two = int_bool(notiffications[1]);
    bool three = int_bool(notiffications[2]);
    bool four = int_bool(notiffications[3]);
    bool five = int_bool(notiffications[4]);
    bool six = int_bool(notiffications[5]);
    bool seven = int_bool(notiffications[6]);
    bool eight = int_bool(notiffications[7]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Notification Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
          color: Colors.white70,
          margin: EdgeInsets.all(3),
          child: SingleChildScrollView(
              child: Column(children: [
            SizedBox(height: 16),
            Center(
              child: SwitchListTileExample(
                  one, '0', widget.app_user, 'Lost & Found'),
            ),
            Center(
              child: SwitchListTileExample(
                  two, '1', widget.app_user, 'Posts (Admins)'),
            ),
            /*           Center(
              child: SwitchListTileExample(
                  three, '2', widget.app_user, 'TimeTables'),
            ),
            Center(
              child: SwitchListTileExample(
                  four, '3', widget.app_user, 'Activities'),
            ),
            Center(
              child:
                  SwitchListTileExample(five, '4', widget.app_user, 'Issues'),
            ),       */
            Center(
              child:
                  SwitchListTileExample(six, '5', widget.app_user, 'Comments'),
            ),
            Center(
              child: SwitchListTileExample(
                  six, '6', widget.app_user, 'Posts (Students)'),
            ),
            Center(
              child: SwitchListTileExample(
                  six, '7', widget.app_user, 'Announcements'),
            ),
            /*        Center(
              child:
                  SwitchListTileExample(six, '8', widget.app_user, 'Messanger'),
            ),      */
          ]))),
    );
  }
}

class SwitchListTileExample extends StatefulWidget {
  bool notif;
  String index;
  Username app_user;
  String title;
  SwitchListTileExample(this.notif, this.index, this.app_user, this.title);

  @override
  State<SwitchListTileExample> createState() => _SwitchListTileExampleState();
}

class _SwitchListTileExampleState extends State<SwitchListTileExample> {
  String bool_int(bool val) {
    if (val == true) {
      return '1';
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _lights = widget.notif;
    return SwitchListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      activeColor: Colors.blue,
      value: _lights,
      onChanged: (bool value) async {
        setState(() {
          _lights = !_lights;
          widget.notif = !widget.notif;
          String settings = widget.app_user.notifSettings!;
          widget.app_user.notifSettings = settings.substring(
                  0, int.parse(widget.index)) +
              bool_int(widget.notif) +
              settings.substring(int.parse(widget.index) + 1, settings.length);
        });
        await menu_bar_servers()
            .edit_notif_settings(widget.index, bool_int(widget.notif));
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}


/*

            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
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
                              const SizedBox(height: 20),
                              const Center(
                                  child: Text(
                                      "Are you sure do you want to delete this?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(height: 10),
                              const Center(
                                  child: Text(
                                      "this will delete your account include posts and and profile information(profile_pic,phn number,etc..)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(height: 10),
                              widget.app_user.email == "shiva@gmail.com"
                                  ? const Center(
                                      child: Text(
                                          "if this is admin account(shiva@gmail.com) it will only delete profile information(profile_pic,phn number) it wont delete complete account as this account is using for testing purpose",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)))
                                  : Container(),
                              Container(
                                margin: const EdgeInsets.all(30),
                                color: Colors.blue[900],
                                child: MaterialButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
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
                                                            "Please wait....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      bool error =
                                          await servers().delete_profile();

                                      if (!error) {
                                        LocalStorage storage =
                                            LocalStorage("usertoken");

                                        storage.clear();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return firstpage(0, widget.app_user);
                                        })); // (Route<dynamic> route) => false
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Failed",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Center(
                                        child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(Icons.delete))

*/