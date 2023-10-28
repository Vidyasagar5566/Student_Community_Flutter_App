import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '/first_page.dart';
import '../Circular_designs/cure_clip.dart';
import '../Circular_designs/circular indicator.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'Servers.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name = "";
String google_email = "";
String imageUrl = "";

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignIn googleuser = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleuser.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user!;

  if (user != null) {
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    name = user.displayName!;
    google_email = user.email!;
    imageUrl = user.photoURL!;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    return google_email;
  }

  return googleSignInAccount.email; // "buddala_b190838ec@nitc.ac.in";
}

Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  FirebaseAuth.instance.signOut();
}

class loginpage extends StatefulWidget {
  String error;
  loginpage(this.error);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //color: Colors.pink[100],
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
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
                          colors: [Colors.deepPurple, Colors.purple.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 90),
                            Text(
                              "Students",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          hintText: 'enter email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                            if (email == "") {
                              email = null;
                            }
                          });
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'please enter email' : null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'password',
                          hintText: 'enter password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                            if (password == "") {
                              password = null;
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
                    (email != null && password != null)
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
                              onPressed: () {
                                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                // builder: (BuildContext context) => logincheck(email, password)));
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            logincheck1(email, password)));
                              },
                              color: Colors.indigo[200],
                              textColor: Colors.black,
                              child: const Text(
                                "Login",
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
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            loginpage(
                                                "Fill all the above details")));
                              },
                              color: Colors.green[200],
                              textColor: Colors.white,
                              child: const Text("Login",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            )),
                    const SizedBox(height: 15),
                    widget.error != ""
                        ? Container(
                            child: Center(
                              child: Text(
                                widget.error,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.blue[900],
                    ),
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          await signOutGoogle();
                          String google_email = "";

                          google_email = await signInWithGoogle();

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      email_check(google_email)),
                              (Route<dynamic> route) => false);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                        ),
                        label: Text("Sign In With Google")),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(25),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("close"))
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Center(
                                      child: Text(
                                          "1. If you continue as guest, you are not allowed to receive any notifications and updates from this app",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 20),
                                  const Center(
                                      child: Text(
                                          "2. Also You are not allowed to share any type of posts, and liking any contents",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 20),
                                  const Center(
                                      child: Text(
                                          "3. Guests are only allowed to read the data inside the app shared by students",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          logincheck1(
                                                              "guest@nitc.ac.in",
                                                              "@Vidyasag5566")),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Continue as guest?",
                                          style: TextStyle(color: Colors.white),
                                        ))),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          });
                    },
                    child: Text("Continue As Guest")),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class email_check extends StatefulWidget {
  String email;
  email_check(this.email);

  @override
  State<email_check> createState() => _email_checkState();
}

class _email_checkState extends State<email_check> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: login_servers().register_email_check(widget.email),
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
            List<dynamic> result = snapshot.data;
            if (!result[0]) {
              return logincheck1(widget.email, result[1]);
            } else {
              return loginpage(
                  "please login with student email_id/check your connection");
            }
          }
        }
        return crclr_ind_appbar();
      },
    );
  }
}

class logincheck1 extends StatefulWidget {
  String email;
  String password;
  logincheck1(this.email, this.password);

  @override
  State<logincheck1> createState() => _logincheck1State();
}

class _logincheck1State extends State<logincheck1> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: login_servers().loginNow(widget.email, widget.password),
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
            bool error = snapshot.data;
            if (!error) {
              return get_ueser_widget(0);
            } else {
              return loginpage("Invalid credidentials/check your connection");
            }
          }
        }
        return crclr_ind_appbar();
      },
    );
  }
}



/*
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    Container(
                        decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage("images/google.png"),
                        fit: BoxFit.cover,
                      ),
                    )),

                    SizedBox(width: 25),

                    // apple button
                  Container(
                      decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage("images/apple.png"),
                      fit: BoxFit.cover,
                    ),
                  )),
                ],
              ),

                const SizedBox(height: 50),

*/