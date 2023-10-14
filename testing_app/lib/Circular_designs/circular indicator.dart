import 'package:flutter/material.dart';
import '../first_page.dart';
import '../main.dart';
import 'package:testing_app/Login/login.dart';

class crclr_ind extends StatefulWidget {
  const crclr_ind({super.key});

  @override
  State<crclr_ind> createState() => _crclr_indState();
}

class _crclr_indState extends State<crclr_ind> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height / 2) - 200),
                height: 140,
                width: 165,
                child: Image.asset("images/icon.png")),
          ),
          const SizedBox(height: 30),
          const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class crclr_ind_out_appbar extends StatefulWidget {
  const crclr_ind_out_appbar({super.key});

  @override
  State<crclr_ind_out_appbar> createState() => _crclr_ind_out_appbarState();
}

class _crclr_ind_out_appbarState extends State<crclr_ind_out_appbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 2) - 200),
                  height: 140,
                  width: 165,
                  child: Image.asset("images/icon.png")),
            ),
            const SizedBox(height: 30),
            const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class crclr_ind_appbar extends StatefulWidget {
  const crclr_ind_appbar({super.key});

  @override
  State<crclr_ind_appbar> createState() => _crclr_ind_appbarState();
}

class _crclr_ind_appbarState extends State<crclr_ind_appbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "InstaBook",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent[700],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 2) - 200),
                  height: 140,
                  width: 165,
                  child: Image.asset("images/icon.png")),
            ),
            const SizedBox(height: 30),
            /*const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),*/
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class crclr_ind_error extends StatefulWidget {
  const crclr_ind_error({super.key});

  @override
  State<crclr_ind_error> createState() => _crclr_ind_errorState();
}

class _crclr_ind_errorState extends State<crclr_ind_error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "InstaBook",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent[700],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 2) - 205),
                  height: 140,
                  width: 165,
                  child: Image.asset("images/icon.png")),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Check your connection',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => get_ueser_widget(0)));
                },
                child: const Text(
                  "Retry",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                )),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => loginpage("")));
                },
                child: const Text(
                  "Return to login page",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }
}

class check_connect_error extends StatefulWidget {
  const check_connect_error({super.key});

  @override
  State<check_connect_error> createState() => _check_connect_errorState();
}

class _check_connect_errorState extends State<check_connect_error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "InstaBook",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent[700],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: const [
            SizedBox(height: 10),
            Center(
              child: Text(
                'Check your connection',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
    ;
  }
}

class networl_error extends StatefulWidget {
  const networl_error({super.key});

  @override
  State<networl_error> createState() => _networl_errorState();
}

class _networl_errorState extends State<networl_error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "InstaBook",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.indigoAccent[700],
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: const Center(
            child: Text(
              "Some thing went wrong please try again",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
