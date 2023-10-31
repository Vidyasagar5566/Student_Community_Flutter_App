import 'package:flutter/material.dart';
import 'Servers.dart';
import '/User_profile/Models.dart';
import 'Models.dart';

class notif_settings extends StatefulWidget {
  Username app_user;
  notif_settings(this.app_user);

  @override
  State<notif_settings> createState() => _notif_settingsState();
}

class _notif_settingsState extends State<notif_settings> {
  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder<List<NotificationsFilter>>(
          future: menu_bar_servers().notif_settings_get(),
          builder: (ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                List<NotificationsFilter> notif_settings = snapshot.data;
                return notif_settings1(notif_settings[0], widget.app_user);
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class notif_settings1 extends StatefulWidget {
  NotificationsFilter notif_settings;
  Username app_user;
  notif_settings1(this.notif_settings, this.app_user);

  @override
  State<notif_settings1> createState() => _notif_settings1State();
}

class _notif_settings1State extends State<notif_settings1> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        margin: EdgeInsets.all(3),
        child: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 16),
          Center(
            child: SwitchListTileExample(widget.notif_settings.lstBuy!,
                widget.notif_settings, widget.app_user, 'L&F_B&S'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.postsAdmin!,
                widget.notif_settings, widget.app_user, 'Posts (Admins)'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.posts!,
                widget.notif_settings, widget.app_user, 'Posts (Students)'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.events!,
                widget.notif_settings, widget.app_user, 'Activities'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.threads!,
                widget.notif_settings, widget.app_user, 'Issues'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.comments!,
                widget.notif_settings, widget.app_user, 'Comments'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.announcements!,
                widget.notif_settings, widget.app_user, 'Announcements'),
          ),
          Center(
            child: SwitchListTileExample(widget.notif_settings.messanger!,
                widget.notif_settings, widget.app_user, 'Messanger'),
          ),
        ])));
  }
}

class SwitchListTileExample extends StatefulWidget {
  bool notif;
  NotificationsFilter notif_settings;
  Username app_user;
  String title;
  SwitchListTileExample(
      this.notif, this.notif_settings, this.app_user, this.title);

  @override
  State<SwitchListTileExample> createState() => _SwitchListTileExampleState();
}

class _SwitchListTileExampleState extends State<SwitchListTileExample> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      activeColor: Colors.blue,
      value: widget.notif,
      onChanged: (bool value) async {
        setState(() {
          widget.notif = !widget.notif;
          if (widget.title == 'L&F_B&S') {
            widget.notif_settings.lstBuy = widget.notif;
          } else if (widget.title == 'L&F_B&S') {
            widget.notif_settings.lstBuy = widget.notif;
          } else if (widget.title == 'Posts (Admins)') {
            widget.notif_settings.postsAdmin = widget.notif;
          } else if (widget.title == 'Posts (Students)') {
            widget.notif_settings.posts = widget.notif;
          } else if (widget.title == 'Activities') {
            widget.notif_settings.events = widget.notif;
          } else if (widget.title == 'Issues') {
            widget.notif_settings.threads = widget.notif;
          } else if (widget.title == 'Comments') {
            widget.notif_settings.comments = widget.notif;
          } else if (widget.title == 'Announcements') {
            widget.notif_settings.announcements = widget.notif;
          } else if (widget.title == 'Messanger') {
            widget.notif_settings.messanger = widget.notif;
          }
        });
        await menu_bar_servers().notif_settings_edit(
            widget.notif_settings.lstBuy!,
            widget.notif_settings.posts!,
            widget.notif_settings.postsAdmin!,
            widget.notif_settings.events!,
            widget.notif_settings.threads!,
            widget.notif_settings.comments!,
            widget.notif_settings.announcements!,
            widget.notif_settings.messanger!);
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