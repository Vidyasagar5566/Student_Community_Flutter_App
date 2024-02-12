import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Login/Models.dart';
import '/Login/Servers.dart';
import '/Login/login.dart';

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
                  ListView.builder(
                      itemCount: filterUnivList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 10),
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
    return ListTile(
      leading: university.univPicRatio == 1
          ? CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(university.unvPic!)))
          : const CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.apartment,
                size: 40,
                color: Colors.black,
              )),
      title: Container(
        padding: EdgeInsets.only(left: 20),
        width: (width - 36) / 1.8,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                child: Text(
                  university.unvName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreya(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
                ),
              ),
            ],
          ),
          Text(
            university.unvLocation!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ]),
      ),
      onTap: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return logincheck1("guest" + university.domain!, "@Vidyasag5566");
        }), (Route<dynamic> route) => false);
      },
    );
  }
}
