import 'dart:convert';



import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:testing_app/Universities/Models.dart';
import 'package:url_launcher/url_launcher.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<String> uniDetails = ["About", "Courses & Fees", "Placements", "Hostels"];
List<Container> get_tabs() {
  List<Container> tabs = [];
  for (int i = 0; i < uniDetails.length; i++) {
    tabs.add(
      Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Tab(
          child: Text(
            uniDetails[i],
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
  return tabs;
}

class universityDetails extends StatefulWidget {
  Universities university;
  universityDetails({super.key, required this.university});

  @override
  State<universityDetails> createState() => _universityDetailsState();
}

class _universityDetailsState extends State<universityDetails> {
  @override
  Widget build(BuildContext context) {
    final double coverheight = 140;
    final double profileheight = 50;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        centerTitle: false,
        title: Text(
          widget.university.unvName!,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
      ),
      body: DefaultTabController(
        length: uniDetails.length,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(4),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.university.unvPic!,
                      width: double.infinity,
                      height: coverheight,
                      fit: BoxFit.cover,
                    ))),
            SizedBox(
                height: 50,
                child: TabBar(
                  unselectedLabelColor: Colors.blueAccent,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: get_tabs(),
                )),
            Expanded(
                child: TabBarView(children: [
              _details(widget.university.about!),
              _details(widget.university.fees! + widget.university.courses!),
              _details(widget.university.placements!),
              _details(widget.university.hostels!),
            ]))
          ],
        ),
      ),
    );
  }

  Widget _details(String details) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          SelectableLinkify(
            onOpen: (url) async {
              if (await canLaunch(url.url)) {
                await launch(url.url);
              } else {
                throw 'Could not launch $url';
              }
            },
            text: utf8convert(details),
          ),
        ],
      ),
    ));
  }
}
