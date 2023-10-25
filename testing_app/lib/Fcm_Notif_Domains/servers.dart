//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// NOTIFICATIONS

// 1 lst_buy, 2 posts, 3 posts_admin, 4 events, 5 threads, 6 comments, 7 announcements, 8 messanger

  Future<bool> send_notifications(
      String title, String description, int notiff_sett) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/send_notifications1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'notiff_sett': notiff_sett
        }),
      );

      var data = json.decode(response.body) as Map;
      print(data);
      return data['error'];
    } catch (e) {
      print("error");
      return true;
    }
  }

  Future<bool> send_announce_notifications(String title, String description,
      int notiff_sett, String notif_year, String notif_branch) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/send_notifications1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'notiff_sett': notiff_sett,
          'notif_branchs': notif_branch,
          'notif_year': notif_year
        }),
      );

      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }
}

var course_list = ['B.Tech', 'M.Tech', 'PG', 'Phd', 'MBA'];

var domains = {
  'All': 'All',
  '@nitt.edu': 'Nit Trichy',
  '@nitk.edu.in': 'Nit Surathkal',
  '@nitrkl.ac.in': 'Nit Rourkela',
  '@nitw.ac.in': ' Nit Warangal',
  '@nitc.ac.in': 'Nit Calicut',
  '@vnit.ac.in': 'Nit Nagpur',
  '@nitdgp.ac.in': 'Nit Durgapur',
  '@nits.ac.in': 'Nit Silchar',
  '@mnit.ac.in': 'Nit Jaipur',
  '@mnnit.ac.in': 'Nit Allahabad',
  '@nitkkr.ac.in': 'Nit Kurukshetra',
  '@nitj.ac.in': ' Nit Jalandhar',
  '@svnit.ac.in': ' Nit Surat',
  '@nitm.ac.in': 'Nit Meghalaya',
  '@nitp.ac.in': 'Nit Patna',
  '@nitrr.ac.in': 'Nit Raipur',
  '@nitsri.ac.in': 'Nit Srinagar',
  '@manit.ac.in': 'Nit Bhopal',
  '@nita.ac.in': 'Nit Agarthala',
  '@nitgoa.ac.in': 'Nit Goa',
  '@nitjsr.ac.in': 'Nit Jamshedpur',
  '@nitmanipur.ac.in': 'Nit Manipur',
  '@nith.ac.in': 'Nit Hamper',
  '@nituk.ac.in': ' Nit Uttarakhand',
  '@nitpy.ac.in': 'Nit Puducherry',
  '@nitap.ac.in': 'Nit ArunaChalPradesh',
  '@nitsikkim.ac.in': 'Nit Sikkim',
  '@nitdelhi.ac.in': 'Nit Delhi',
  '@nitmz.ac.in': 'Nit Mizoram',
  '@nitnagaland.ac.in': 'Nit Nagaland',
  '@nitandhra.ac.in': 'Nit AndhraPradesh',
//IITS
  '@iitm.ac.in': 'IIT Madras',
  '@iitd.ac.in': 'IIT Delhi',
  '@iitb.ac.in': 'IIT Bombay',
  '@iitk.ac.in': 'IIT Kanpur',
  '@iitr.ac.in': 'IITR Rookee',
  '@iitkgp.ac.in': 'IIT Kharagpur',
  '@iitg.ac.in': 'IIT Guwahati',
  '@iith.ac.in': 'IIT Hyderabad',
  '@iitbhu.ac.in': 'IIT BHU',
  '@iitism.ac.in': 'IIT ISM Dhanbad',
  '@iiti.ac.in': 'IIT Indore',
  '@iitrpr.ac.in': 'IIT Rupar',
  '@iitmandi.ac.in': 'IIT Mandi',
  '@iitgn.ac.in': 'IIT Gandhinagar',
  '@iitj.ac.in': 'IIT Jodhpur',
  '@iitp.ac.in': 'IIT Patna',
  '@iitbbs.ac.in': 'IIT Bhubaneswar',
  '@iittp.ac.in': 'IIT Tirupati',
  '@iitpkd.ac.in': 'IIT Palakkad',
  '@iitjammu.ac.in': 'IIT Jammu',
  '@iitdh.ac.in': 'IIT Dharwad',
  '@iitbhilai.ac.in': 'IIT Bhilai',
};

var domains1 = {
  'All': 'All',
  'Nit Trichy': '@nitt.edu',
  'Nit Surathkal': '@nitk.edu.in',
  'Nit Rourkela': '@nitrkl.ac.in',
  'Nit Warangal': '@nitw.ac.in',
  'Nit Calicut': '@nitc.ac.in',
  'Nit Nagpur': '@vnit.ac.in',
  'Nit Durgapur': '@nitdgp.ac.in',
  'Nit Silchar': '@nits.ac.in',
  'Nit Jaipur': '@mnit.ac.in',
  'Nit Allahabad': '@mnnit.ac.in',
  'Nit Kurukshetra': '@nitkkr.ac.in',
  'Nit Jalandhar': '@nitj.ac.in',
  'Nit Surat': '@svnit.ac.in',
  'Nit Meghalaya': '@nitm.ac.in',
  'Nit Patna': '@nitp.ac.in',
  'Nit Raipur': '@nitrr.ac.in',
  'Nit Srinagar': '@nitsri.ac.in',
  'Nit Bhopal': '@manit.ac.in',
  'Nit Agarthala': '@nita.ac.in',
  'Nit Goa': '@nitgoa.ac.in',
  'Nit Jamshedpur': '@nitjsr.ac.in',
  'Nit Manipur': '@nitmanipur.ac.in',
  'Nit Hamper': '@nith.ac.in',
  'Nit Uttarakhand': '@nituk.ac.in',
  'Nit Puducherry': '@nitpy.ac.in',
  'Nit ArunaChalPradesh': '@nitap.ac.in',
  'Nit Sikkim': '@nitsikkim.ac.in',
  'Nit Delhi': '@nitdelhi.ac.in',
  'Nit Mizoram': '@nitmz.ac.in',
  'Nit Nagaland': '@nitnagaland.ac.in',
  'Nit AndhraPradesh': '@nitandhra.ac.in',

//IITS

  'IIT Madras': '@iitm.ac.in',
  'IIT Delhi': '@iitd.ac.in',
  'IIT Bombay': '@iitb.ac.in',
  'IIT Kanpur': '@iitk.ac.in',
  'IITR Rookee': '@iitr.ac.in',
  'IIT Kharagpur': '@iitkgp.ac.in',
  'IIT Guwahati': '@iitg.ac.in',
  'IIT Hyderabad': '@iith.ac.in',
  'IIT BHU': '@iitbhu.ac.in',
  'IIT ISM Dhanbad': '@iitism.ac.in',
  'IIT Indore': '@iiti.ac.in',
  'IIT Rupar': '@iitrpr.ac.in',
  'IIT Mandi': '@iitmandi.ac.in',
  'IIT Gandhinagar': '@iitgn.ac.in',
  'IIT Jodhpur': '@iitj.ac.in',
  'IIT Patna': '@iitp.ac.in',
  'IIT Bhubaneswar': '@iitbbs.ac.in',
  'IIT Tirupati': '@iittp.ac.in',
  'IIT Palakkad': '@iitpkd.ac.in',
  'IIT Jammu': '@iitjammu.ac.in',
  'IIT Dharwad': '@iitdh.ac.in',
  'IIT Bhilai': '@iitbhilai.ac.in'
};

List<String> domains_list2 = [
  'All',
  '@nitt.edu',
  '@nitk.edu.in',
  '@nitrkl.ac.in',
  '@nitw.ac.in',
  '@nitc.ac.in',
  '@vnit.ac.in',
  '@nitdgp.ac.in',
  '@nits.ac.in',
  '@mnit.ac.in',
  '@mnnit.ac.in',
  '@nitkkr.ac.in',
  '@nitj.ac.in',
  '@svnit.ac.in',
  '@nitm.ac.in',
  '@nitp.ac.in',
  '@nitrr.ac.in',
  '@nitsri.ac.in',
  '@manit.ac.in',
  '@nita.ac.in',
  '@nitgoa.ac.in',
  '@nitjsr.ac.in',
  '@nitmanipur.ac.in',
  '@nith.ac.in',
  '@nituk.ac.in',
  '@nitpy.ac.in',
  '@nitap.ac.in',
  '@nitsikkim.ac.in',
  '@nitdelhi.ac.in',
  '@nitmz.ac.in',
  '@nitnagaland.ac.in',
  '@nitandhra.ac.in',

//IITS

  '@iitm.ac.in',
  '@iitd.ac.in',
  '@iitb.ac.in',
  '@iitk.ac.in',
  '@iitr.ac.in',
  '@iitkgp.ac.in',
  '@iitg.ac.in',
  '@iith.ac.in',
  '@iitbhu.ac.in',
  '@iitism.ac.in',
  '@iiti.ac.in',
  '@iitrpr.ac.in',
  '@iitmandi.ac.in',
  '@iitgn.ac.in',
  '@iitj.ac.in',
  '@iitp.ac.in',
  '@iitbbs.ac.in',
  '@iittp.ac.in',
  '@iitpkd.ac.in',
  '@iitjammu.ac.in',
  '@iitdh.ac.in',
  '@iitbhilai.ac.in',
];

List<String> domains_list = [
  'All',
  'Nit Trichy',
  'Nit Surathkal',
  'Nit Rourkela',
  'Nit Warangal',
  'Nit Calicut',
  'Nit Nagpur',
  'Nit Durgapur',
  'Nit Silchar',
  'Nit Jaipur',
  'Nit Allahabad',
  'Nit Kurukshetra',
  'Nit Jalandhar',
  'Nit Surat',
  'Nit Meghalaya',
  'Nit Patna',
  'Nit Raipur',
  'Nit Srinagar',
  'Nit Bhopal',
  'Nit Agarthala',
  'Nit Goa',
  'Nit Jamshedpur',
  'Nit Manipur',
  'Nit Hamper',
  'Nit Uttarakhand',
  'Nit Puducherry',
  'Nit ArunaChalPradesh',
  'Nit Sikkim',
  'Nit Delhi',
  'Nit Mizoram',
  'Nit Nagaland',
  'Nit AndhraPradesh',

//IITS

  'IIT Madras',
  'IIT Delhi',
  'IIT Bombay',
  'IIT Kanpur',
  'IITR Rookee',
  'IIT Kharagpur',
  'IIT Guwahati',
  'IIT Hyderabad',
  'IIT BHU',
  'IIT ISM Dhanbad',
  'IIT Indore',
  'IIT Rupar',
  'IIT Mandi',
  'IIT Gandhinagar',
  'IIT Jodhpur',
  'IIT Patna',
  'IIT Bhubaneswar',
  'IIT Tirupati',
  'IIT Palakkad',
  'IIT Jammu',
  'IIT Dharwad',
  'IIT Bhilai',
];


//    path('', views.testing.as_view(),name = 'login'),
//    path('login', obtain_auth_token),
//    path('register', views.Register.as_view(),name = 'Register'),
//    path('get_user', views.GET_user.as_view(),name = 'GET_user'),
//    path('lost_found/list', views.LST_list.as_view(),name = 'LST_list'),
//    path('lost_found/comment_list', views.LST_Comment_list.as_view(),name = 'LST_Comment_list'),
//    path('post/list', views.POST_list.as_view(),name = 'POST_list'),
//    path('post/comment_list', views.PST_CMNT_list.as_view(),name = 'PST_CMNT_list'),
//    path('post/like_list', views.POST_LIKE_list.as_view(),name = 'POST_LIKE_list'),
//    path('event/list', views.EVENT_list.as_view(),name = 'EVENT_list'),
//    path('event/like_list', views.EVENT_LIKE_list.as_view(),name = 'EVENT_LIKE_list'),
//    path('alert/list', views.ALERT_list.as_view(),name = 'ALERT_list'),
//    path('alert/comment_list', views.ALERT_CMNT_list.as_view(),name = 'ALERT_comment_list'),
//    path('club_sport/list', views.CLUB_SPORT_list.as_view(),name = 'CLUB_SPORT_list'),
//    path('club_sport/edit', views.CLUB_SPORT_edit.as_view(),name = 'CLUB_SPORT_edit'),
//    path('club_sport/like_list', views.CLUB_SPORT_like_list.as_view(),name = 'CLUB_SPORT_like_list'),
//    path('club_sport/memb', views.CLUB_SPORT_MEMB.as_view(),name = 'CLUB_SPORT'),
//    path('profile/list', views.PEOFILE_list.as_view(),name = 'PEOFILE_list'),
//    path('sac/list', views.SAC_list.as_view(),name = 'SAC_list'),
//    path('mess/list', views.MESS_list.as_view(),name = 'ACADEMIC_list'),
//    path('academic/list', views.ACADEMIC_list.as_view(),name = 'ACADEMIC_list'),
//    path('notifications', views.Notifications.as_view(),name = 'Notifications'),
//    path('edit_notif_settings', views.EDIT_notif_settings.as_view(),name = 'EDIT_notif_settings'),
// MESSANGER
//    path('messanger1', views.Messanger.as_view(),name = 'Messanger1'),
//    path('user_messanger1', views.USER_Messanger.as_view(),name = 'user_messanger1'),
//CALENDER_EVENT
//    path('all_branches/list1', views.ALL_BRANCHES.as_view(),name = 'ALL_BRANCHES'),
//    path('cal_dates_subs/list1', views.CALENDER_DATE_SUBS.as_view(),name = 'CALENDER_DATE_SUBS'),   #include subjects
//    path('cal_sub_years/list1', views.CALENDER_SUB_YEARS.as_view(),name = 'CALENDER_SUB_YEARS'),
//    path('calender_sub_files1', views.CALENDER_SUB_FILES.as_view(),name = 'CALENDER_SUB_FILES'),
//    path('cal_events/list1', views.CALENDER_EVENTS_list.as_view(),name = 'CALENDER_EVENTS_list'),
//    path('ratings', views.RATINGS.as_view(),name = 'RATINGS'),

//   path('security1', views.SECURITY.as_view(),name = 'SECURITY1'),
