import 'package:flutter/material.dart';

class privacyPolicy extends StatefulWidget {
  const privacyPolicy({super.key});

  @override
  State<privacyPolicy> createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: const Text("Privacy Policy for Esmus App",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          const Text(
              "Welcome to Esmus! This Privacy Policy outlines how we collect, use, and protect your information when you use the Esmus mobile application.",
              style: TextStyle(fontSize: 25)),
          Container(
            margin: EdgeInsets.all(10),
            child: const Text(
              '''
                University Details: Esmus displays information about IIT (Indian Institutes of Technology) and NIT (National Institutes of Technology) universities. We provide details based on publicly available information and strive to ensure accuracy to the best of our knowledge.
                Student Ratings: Ratings and reviews provided by students are displayed on the app. Users have the option to submit ratings and reviews anonymously.
                Use of Information:
                              
                Accuracy Disclaimer: While we make every effort to provide accurate and up-to-date information, details about universities and student ratings are presented "as is" and may be subject to change. Users should verify information independently.
                User Contributions: Users are encouraged to contribute ratings and reviews to enhance the community's knowledge. If any user feels that information is incorrect, they are welcome to suggest corrections through the app.
                Data Protection:
                              
                Security Measures: We implement reasonable security measures to protect your data. However, as no data transmission over the internet can be guaranteed as 100% secure, we cannot ensure or warrant the security of any information you transmit.
                Third-Party Links: The app may contain links to third-party websites or services. We are not responsible for the privacy practices or content of these third-party sites.
                              
                Data Access and Correction: Users can access and correct their personal information through the app. For assistance, contact [insert contact email].
                Suggestions and Concerns: If users have suggestions or concerns about the displayed information, they are encouraged to contact us at [insert contact email] before lodging a complaint.''',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: const Text("Changes to the Privacy Policy:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          const Text(
              "We may update this Privacy Policy from time to time. Users will be notified of any significant changes through the app.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          Container(
            margin: EdgeInsets.all(10),
            child: const Text("Contact Us:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          const Text(
              '''If you have any questions or concerns regarding this Privacy Policy, please contact us at studentcommunity.iit.nit@gmail.com.
                  By using the Esmus app, you agree to the terms outlined in this Privacy Policy.
                  Please replace the placeholders like "[insert date]" and "[insert contact email]" with the relevant information. Additionally, consider seeking legal advice to ensure compliance with regional privacy laws and regulations.''',
              style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
