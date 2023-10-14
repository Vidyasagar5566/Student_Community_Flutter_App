import 'package:flutter/material.dart';
import '/main.dart';
import 'package:localstorage/localstorage.dart';
import '/models/models.dart';
import 'package:testing_app/user_profile/edit_profile.dart';
import 'about_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../side_menu_bar/settings.dart';
import 'package:testing_app/Login/login.dart';

class NavDrawer extends StatefulWidget {
  Username app_user;
  NavDrawer(this.app_user);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  bool about = false;
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo[800],
            ),
            child: Column(
              children: [
                CircleAvatar(
                    radius: 63,
                    backgroundColor: Colors.white,
                    child: widget.app_user.fileType! == '1'
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                //post.profile_pic
                                NetworkImage(widget.app_user.profilePic!))
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                //post.profile_pic
                                AssetImage("images/profile.jpg")))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Edit profile'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return editprofile(widget.app_user);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => notif_settings(
                      widget.app_user) //notif_settings(widget.app_user)
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              await GoogleSignIn().signOut();
              LocalStorage storage = LocalStorage("usertoken");
              storage.clear();

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => loginpage("")));
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Help Center'),
            onTap: () => {
              setState(() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return about_app(widget.app_user); //event_photowidget
                }));
              }),
              //Navigator.of(context).pop()
            },
          ),
          const Divider(
            color: Colors.grey,
            height: 35,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
