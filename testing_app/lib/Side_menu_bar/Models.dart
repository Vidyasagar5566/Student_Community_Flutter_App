class NotificationsFilter {
  int? id;
  String? fcmToken;
  bool? lstBuy;
  bool? posts;
  bool? postsAdmin;
  bool? events;
  bool? threads;
  bool? comments;
  bool? announcements;
  bool? messanger;
  int? username;

  NotificationsFilter(
      {this.id,
      this.fcmToken,
      this.lstBuy,
      this.posts,
      this.postsAdmin,
      this.events,
      this.threads,
      this.comments,
      this.announcements,
      this.messanger,
      this.username});

  NotificationsFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fcmToken = json['fcm_token'];
    lstBuy = json['lst_buy'];
    posts = json['posts'];
    postsAdmin = json['posts_admin'];
    events = json['events'];
    threads = json['threads'];
    comments = json['comments'];
    announcements = json['announcements'];
    messanger = json['messanger'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fcm_token'] = this.fcmToken;
    data['lst_buy'] = this.lstBuy;
    data['posts'] = this.posts;
    data['posts_admin'] = this.postsAdmin;
    data['events'] = this.events;
    data['threads'] = this.threads;
    data['comments'] = this.comments;
    data['announcements'] = this.announcements;
    data['messanger'] = this.messanger;
    data['username'] = this.username;
    return data;
  }
}
