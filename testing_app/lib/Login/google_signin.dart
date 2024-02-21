import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_app/Login/guestLogin.dart';
import '/First_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Circular_designs/Circular_Indicator.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'Servers.dart';
import 'login.dart';

class latest_loginpage extends StatefulWidget {
  String error;
  String domain;
  latest_loginpage(this.error, this.domain);

  @override
  State<latest_loginpage> createState() => _latest_loginpageState();
}

class _latest_loginpageState extends State<latest_loginpage> {
  List imageList = [
    {
      "id": 1,
      "image_path": 'images/sliders/events.png',
      "name": "Campus Activities"
    },
    {
      "id": 2,
      "image_path": 'images/sliders/academic.png',
      "name": "Clubs, Fests, Sports"
    },
    {
      "id": 3,
      "image_path": 'images/sliders/parents.png',
      "name": "Placements, Announcements, Chattings"
    }
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  bool errorShowed = false;
  @override
  Widget build(BuildContext context) {
    if (widget.error != "" && errorShowed == false) {
      Future.delayed(Duration.zero, () {
        setState(() {
          errorShowed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            content:
                Text(widget.error, style: TextStyle(color: Colors.white))));
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("ESMUS",
                  style: GoogleFonts.alegreya(
                      textStyle: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold))),
              Text("University Community",
                  style: GoogleFonts.alegreya(
                      textStyle: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold))),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CarouselSlider(
                      items: imageList
                          .map(
                            (item) => Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(item['image_path']),
                                      fit: BoxFit.cover)),
                            ),
                          )
                          .toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        autoPlayInterval: Duration(milliseconds: 1500),
                        // aspectRatio: 1,
                        // viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: currentIndex == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentIndex == entry.key
                                    ? Colors.red
                                    : Colors.teal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80, bottom: 100),
              decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
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
                          label: Text("Sign In With Student Email")),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return guestLogin();
                              }));
                            },
                            child: const Text("Guest Login?",
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white))),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return loginpage(
                                  "",
                                  widget
                                      .domain); //domains[widget.app_user.domain]!);
                            }));
                          },
                          child: const Text("Admin Login?",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white)))
                    ],
                  ),
                )
              ]),
            )
          ],
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
              return latest_loginpage(
                  "please login with student email_id/check your connection",
                  'Nit Calicut');
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
              return latest_loginpage(
                  "Invalid credidentials/check your connection", 'Nit Calicut');
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