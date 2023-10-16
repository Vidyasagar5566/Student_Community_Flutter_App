class Username {
  int? id;
  String? password;
  bool? isSuperuser;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? email;
  String? username;
  String? password1;
  String? rollNum;
  String? phnNum;
  String? profilePic;
  String? fileType;
  String? bio;
  var skills;
  String? course;
  String? branch;
  String? batch;
  int? year;
  String? dateOfBirth;
  bool? isInstabook;
  bool? isFaculty;
  bool? isAdmin;
  bool? isStudentAdmin;
  String? instabookRole;
  String? facultyRole;
  String? adminRole;
  String? studentAdminRole;
  String? userMark;
  int? starMark;
  int? highPostCount;
  int? highLstCount;
  bool? notifSeen;
  int? notifCount;
  String? notifIds;
  String? notifSettings;
  String? token;
  String? platform;
  String? domain;
  bool? isDetails;
  bool? clzClubsHead;
  bool? clzSportsHead;
  bool? clzFestsHead;
  bool? clzSacsHead;
  Map<String, dynamic>? clzClubs;
  Map<String, dynamic>? clzSports;
  Map<String, dynamic>? clzFests;
  Map<String, dynamic>? clzSacs;
  Username(
      {this.id,
      this.password,
      this.isSuperuser,
      this.firstName,
      this.lastName,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.email,
      this.username,
      this.password1,
      this.rollNum,
      this.phnNum,
      this.profilePic,
      this.fileType,
      this.bio,
      this.skills,
      this.course,
      this.branch,
      this.batch,
      this.year,
      this.dateOfBirth,
      this.isInstabook,
      this.isFaculty,
      this.isAdmin,
      this.isStudentAdmin,
      this.instabookRole,
      this.facultyRole,
      this.adminRole,
      this.studentAdminRole,
      this.userMark,
      this.starMark,
      this.highPostCount,
      this.highLstCount,
      this.notifSeen,
      this.notifCount,
      this.notifIds,
      this.notifSettings,
      this.token,
      this.platform,
      this.domain,
      this.isDetails,
      this.clzClubsHead,
      this.clzSportsHead,
      this.clzFestsHead,
      this.clzSacsHead,
      this.clzClubs,
      this.clzSports,
      this.clzFests,
      this.clzSacs});

  Username.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    isSuperuser = json['is_superuser'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    email = json['email'];
    username = json['username'];
    password1 = json['password1'];
    rollNum = json['roll_num'];
    phnNum = json['phn_num'];
    profilePic = json['profile_pic'];
    fileType = json['file_type'];
    bio = json['bio'];
    skills = json['skills'];
    course = json['course'];
    branch = json['branch'];
    batch = json['batch'];
    year = json['year'];
    dateOfBirth = json['date_of_birth'];
    isInstabook = json['is_instabook'];
    isFaculty = json['is_faculty'];
    isAdmin = json['is_admin'];
    isStudentAdmin = json['is_student_admin'];
    instabookRole = json['instabook_role'];
    facultyRole = json['faculty_role'];
    adminRole = json['admin_role'];
    studentAdminRole = json['student_admin_role'];
    userMark = json['user_mark'];
    starMark = json['star_mark'];
    highPostCount = json['high_post_count'];
    highLstCount = json['high_lst_count'];
    notifSeen = json['notif_seen'];
    notifCount = json['notif_count'];
    notifIds = json['notif_ids'];
    notifSettings = json['notif_settings'];
    token = json['token'];
    platform = json['platform'];
    domain = json['domain'];
    isDetails = json['is_details'];
    clzClubsHead = json['clz_clubs_head'];
    clzSportsHead = json['clz_sports_head'];
    clzFestsHead = json['clz_fests_head'];
    clzSacsHead = json['clz_sacs_head'];
    clzClubs = json['clz_clubs'];
    clzSports = json['clz_sports'];
    clzFests = json['clz_fests'];
    clzSacs = json['clz_sacs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['is_superuser'] = this.isSuperuser;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password1'] = this.password1;
    data['roll_num'] = this.rollNum;
    data['phn_num'] = this.phnNum;
    data['profile_pic'] = this.profilePic;
    data['file_type'] = this.fileType;
    data['bio'] = this.bio;
    data['skills'] = this.skills;
    data['course'] = this.course;
    data['branch'] = this.branch;
    data['batch'] = this.batch;
    data['year'] = this.year;
    data['date_of_birth'] = this.dateOfBirth;
    data['is_instabook'] = this.isInstabook;
    data['is_faculty'] = this.isFaculty;
    data['is_admin'] = this.isAdmin;
    data['is_student_admin'] = this.isStudentAdmin;
    data['instabook_role'] = this.instabookRole;
    data['faculty_role'] = this.facultyRole;
    data['admin_role'] = this.adminRole;
    data['student_admin_role'] = this.studentAdminRole;
    data['user_mark'] = this.userMark;
    data['star_mark'] = this.starMark;
    data['high_post_count'] = this.highPostCount;
    data['high_lst_count'] = this.highLstCount;
    data['notif_seen'] = this.notifSeen;
    data['notif_count'] = this.notifCount;
    data['notif_ids'] = this.notifIds;
    data['notif_settings'] = this.notifSettings;
    data['token'] = this.token;
    data['platform'] = this.platform;
    data['domain'] = this.domain;
    data['is_details'] = this.isDetails;
    data['clz_clubs_head'] = this.clzClubsHead;
    data['clz_sports_head'] = this.clzSportsHead;
    data['clz_fests_head'] = this.clzFestsHead;
    data['clz_sacs_head'] = this.clzSacsHead;
    data['clz_clubs'] = this.clzClubs;
    data['clz_sports'] = this.clzSports;
    data['clz_fests'] = this.clzFests;
    data['clz_sacs'] = this.clzSacs;
    return data;
  }
}

class SmallUsername {
  String? username;
  String? domain;
  String? email;
  String? rollNum;
  String? profilePic;
  String? fileType;
  String? phnNum;
  bool? isStudentAdmin;
  String? userMark;
  int? starMark;

  SmallUsername(
      {this.username,
      this.domain,
      this.email,
      this.rollNum,
      this.profilePic,
      this.phnNum,
      this.fileType,
      this.isStudentAdmin,
      this.userMark,
      this.starMark});

  SmallUsername.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    domain = json['domain'];
    email = json['email'];
    rollNum = json['roll_num'];
    profilePic = json['profile_pic'];
    phnNum = json['phn_num'];
    fileType = json['file_type'];
    isStudentAdmin = json['is_student_admin'];
    userMark = json['user_mark'];
    starMark = json['star_mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['domain'] = this.domain;
    data['email'] = this.email;
    data['roll_num'] = this.rollNum;
    data['profile_pic'] = this.profilePic;
    data['phn_num'] = this.phnNum;
    data['file_type'] = this.fileType;
    data['is_student_admin'] = this.isStudentAdmin;
    data['user_mark'] = this.userMark;
    data['star_mark'] = this.starMark;
    return data;
  }
}

SmallUsername user_min(Username app_user) {
  SmallUsername min_user = SmallUsername();
  min_user.username = app_user.username;
  min_user.domain = app_user.domain;
  min_user.email = app_user.email;
  min_user.rollNum = app_user.rollNum;
  min_user.profilePic = app_user.profilePic;
  min_user.fileType = app_user.fileType;
  min_user.phnNum = app_user.phnNum;
  min_user.isStudentAdmin = app_user.isStudentAdmin;
  return min_user;
}


/*
class snack_bar_display extends StatefulWidget {
  String text;
  snack_bar_display(this.text);

  @override
  State<snack_bar_display> createState() => _snack_bar_displayState();
}

class _snack_bar_displayState extends State<snack_bar_display> {
  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return Container(); 
  }
} */



