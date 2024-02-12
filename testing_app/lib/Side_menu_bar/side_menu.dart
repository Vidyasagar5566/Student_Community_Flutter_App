import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:testing_app/Login/latest_login.dart';
import 'package:testing_app/User_Star_Mark/Edit_User_star_mark.dart';
import '/Side_menu_bar/Settings.dart';
import '/User_profile/Models.dart';
import '/User_profile/Edit_profile.dart';
import 'About_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Login/Login.dart';

class NavDrawer extends StatefulWidget {
  Username app_user;
  NavDrawer(this.app_user);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
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
                                AssetImage("images/profile.jpg"))),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Edit profile',
                style: GoogleFonts.alegreya(
                    textStyle: TextStyle(color: Colors.black))),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return editprofile(widget.app_user);
              }));
            },
          ),
          widget.app_user.clzUsersHead!
              ? ListTile(
                  leading: Icon(Icons.person_4_outlined),
                  title: Text('Edit User profile'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return editUserStarMark(
                          widget.app_user, widget.app_user.domain!);
                    }));
                  },
                )
              : Container(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings',
                style: GoogleFonts.alegreya(
                    textStyle: TextStyle(color: Colors.black))),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => notif_settings(
                      widget.app_user) //notif_settings(widget.app_user)
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('Logout',
                style: GoogleFonts.alegreya(
                    textStyle: TextStyle(color: Colors.black))),
            onTap: () async {
              await GoogleSignIn().signOut();
              LocalStorage storage = LocalStorage("usertoken");
              storage.clear();

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      latest_loginpage("", 'Nit Calicut')));
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Help Center',
                style: GoogleFonts.alegreya(
                    textStyle: TextStyle(color: Colors.black))),
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
