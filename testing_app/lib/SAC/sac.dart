import 'package:flutter/material.dart';
//import 'package:testing_app/dataset.dart';
import '/models/models.dart';
import '/servers/servers.dart';

List<Tab> tabs = const [
  Tab(
      child: Icon(
    Icons.person,
    size: 31,
  )),
  Tab(child: Icon(Icons.call, size: 31)),
  Tab(
    child: Icon(Icons.abc_outlined, size: 31),
  ),
];

List<Widget> tabscontent = [
  Container(
    child: const Center(
      child: Text(
        '''Academic Affairs secretory(AAS)''',
        //post.description,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  Container(
    child: const Center(
      child: Text(
        '''+91 000 000 000''',
        //post.description,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  Container(
    child: Container(
      margin: EdgeInsets.all(8),
      child: const Text(
        "The Academic Secretary is responsible for the administration of the University's academic business and for the oversight of University academic policy. University academic business and policy (academic affairs) is controlled by Academic Council. Academic Council is the primary internal body responsible for academic affairs and derives",
        style: TextStyle(fontSize: 12),
      ),
    ),
  )
];

class sacpagewidget extends StatefulWidget {
  Username app_user;
  String domain;
  sacpagewidget(this.app_user, this.domain);

  @override
  State<sacpagewidget> createState() => _sacpagewidgetState();
}

class _sacpagewidgetState extends State<sacpagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: false,
          title: const Text(
            "SAC PAGE",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            DropdownButton<String>(
                value: widget.domain,
                underline: Container(),
                elevation: 0,
                items:
                    domains_list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.domain = value!;
                  });
                })
          ],
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<Username>>(
          future: servers().get_sac_list(domains1[widget.domain]!),
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
                List<Username> sac_list = snapshot.data;
                return _buildListView(sac_list);
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _buildListView(List<Username> sac_list) {
    return sac_list.isEmpty
        ? Container(
            margin: EdgeInsets.all(100),
            child: const Center(
              child: Text("No Data Was Found"),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //image: post.post_pic,
                    image: AssetImage("images/event background.jpg"),
                    fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: ListView.builder(
                  itemCount: sac_list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10),
                  itemBuilder: (BuildContext context, int index) {
                    Username sac_mem = sac_list[index];
                    return _buildLoadingScreen(sac_mem);
                  }),
            ));
  }

  Widget _buildLoadingScreen(Username sac_mem) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, //post.profile_pic
                      child: sac_mem.fileType! == '1'
                          ? CircleAvatar(backgroundImage: NetworkImage(
                              //'images/odessay B.jpeg'
                              sac_mem.profilePic!))
                          : const CircleAvatar(backgroundImage: AssetImage(
                              //'images/odessay B.jpeg'
                              "images/profile.jpg")),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: (width - 36) / 1.8,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: (width - 36) / 2.4),
                                  child: Text(
                                    sac_mem.username!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    //"Vidya Sagar",
                                    //lst_list[index].username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      //color: Colors.white
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                9 % 9 == 0
                                    ? const Icon(
                                        Icons
                                            .verified_rounded, //verified_rounded,verified_outlined
                                        color: Colors.green,
                                        size: 18,
                                      )
                                    : Container()
                              ],
                            ),
                            Text(
                              //"B190838EC",
                              domains[sac_mem.domain!]! +
                                  " (" +
                                  sac_mem.userMark! +
                                  ")",
                              overflow: TextOverflow.ellipsis,
                              //lst_list.username.rollNum,
                              //style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            )
                          ]),
                    )
                  ],
                ),
                Icon(Icons.more_horiz)
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
                margin: const EdgeInsets.all(5),
                child: Column(children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        size: 31,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        width: 23,
                      ),
                      Center(
                        child: Text(
                          sac_mem.studentAdminRole!,
                          //'''Academic Affairs secretory(AAS)''',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        size: 29,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Center(
                        child: Text(
                          sac_mem.phnNum!,
                          //'+91 000 000 000',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 15,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: Text(
                      sac_mem.bio!,
                      //"The Academic Secretary is responsible for the administration of the University's academic business and for the oversight of University academic policy. University academic business and policy (academic affairs) is controlled by Academic Council. Academic Council is the primary internal body responsible for academic affairs and derives",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ])),
          ],
        ));
  }
}
