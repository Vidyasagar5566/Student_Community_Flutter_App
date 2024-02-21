import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_app/Universities/universityDetail.dart';
import '/Universities/Models.dart';
import '/Login/Servers.dart';
import '/Login/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class guestLogin extends StatefulWidget {
  const guestLogin({super.key});

  @override
  State<guestLogin> createState() => _guestLoginState();
}

class _guestLoginState extends State<guestLogin> {
  var universityName;
  bool loaded = false;
  List<Universities> UnivList = [];
  List<Universities> filterUnivList = [];

  Future<void> universityList() async {
    UnivList = await login_servers().getUniversities();
    setState(() {
      filterUnivList = List.from(UnivList);
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    universityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select university",
          style:
              GoogleFonts.alegreya(textStyle: TextStyle(color: Colors.black)),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: (){
                
              },
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('LOGIN',
                      textStyle: GoogleFonts.alegreya(
                          color: Colors.green,
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      speed: Duration(milliseconds: 300)),
                ],
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: loaded
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'University name ',
                        hintText: 'NIT Calicut',
                        prefixIcon: Icon(Icons.search, size: 35),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(width: 1)),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          universityName = value;
                          if (universityName == "") {
                            universityName = null;
                          }
                          filterUnivList = UnivList.where((element) =>
                              element.unvName!.toLowerCase().contains(value) ||
                              element.unvName!.toUpperCase().contains(value) ||
                              element.unvName!.contains(value)).toList();
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'please enter email' : null;
                      },
                    ),
                  ),
                  GridView.builder(
                      itemCount: filterUnivList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Universities univ = filterUnivList[index];

                        return _universityProfile_(univ);
                      }),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _universityProfile_(Universities university) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                universityDetails(university: university)));
      },
      child: Container(
        width: (width - 100) / 2,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Container(
                width: (width - 40) / 2,
                height: (width - 100) / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage("images/loading.png"))),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(university.unvPic!),
                            fit: BoxFit.cover))),
              ),
            ),
            const SizedBox(height: 5),
            Container(
                padding: EdgeInsets.all(5),
                width: (width - 20) / 3,
                child: Text(university.unvName!,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis)),
            Row(
              children: [
                givenRating(university.Rating!),
                const SizedBox(width: 4),
                Text(
                  university.Rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "(" + "0.1k" + ")",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            // const SizedBox(height: 15),
            // Container(
            //     margin: EdgeInsets.only(left: 4),
            //     height: 30,
            //     width: 130,
            //     decoration: BoxDecoration(
            //         color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //     child: OutlinedButton(
            //         onPressed: () async {},
            //         child: const Center(
            //             child: Text(
            //           "Fallowing",
            //           style: TextStyle(color: Colors.white),
            //         ))))
          ],
        ),
      ),
    );
  }
}

class givenRating extends StatefulWidget {
  double sub_rating;
  givenRating(this.sub_rating);

  @override
  State<givenRating> createState() => _givenRatingState();
}

class _givenRatingState extends State<givenRating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.sub_rating.floor() >= 1
            ? const Icon(Icons.star, color: Colors.green, size: 20)
            : const Icon(Icons.star_border, color: Colors.black, size: 20),
        widget.sub_rating.floor() >= 2
            ? const Icon(Icons.star, color: Colors.green, size: 20)
            : const Icon(Icons.star_border, color: Colors.black, size: 20),
        widget.sub_rating.floor() >= 3
            ? const Icon(Icons.star, color: Colors.green, size: 20)
            : const Icon(Icons.star_border, color: Colors.black, size: 20),
        widget.sub_rating.floor() >= 4
            ? const Icon(Icons.star, color: Colors.green, size: 20)
            : const Icon(Icons.star_border, color: Colors.black, size: 20),
        widget.sub_rating.floor() >= 5
            ? const Icon(Icons.star, color: Colors.green, size: 20)
            : const Icon(Icons.star_border, color: Colors.black, size: 20),
      ],
    );
  }
}
