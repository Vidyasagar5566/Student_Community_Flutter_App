import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testing_app/Files_disply_download/pdf_videos_images.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';

class single_message extends StatefulWidget {
  Username app_user;
  MessageModel currentmessage;
  single_message(this.app_user, this.currentmessage);

  @override
  State<single_message> createState() => _single_messageState();
}

class _single_messageState extends State<single_message> {
  bool _showController = true;

  @override
  Widget build(BuildContext context) {
    MessageModel message = widget.currentmessage;
    return widget.app_user.email == message.sender
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildScreen(message),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildScreen(message),
            ],
          );
  }

  _buildScreen(MessageModel message) {
    return message.type == 0
        ? _textMessage(message)
        : GestureDetector(
            onTap: () {
              if (!message.insert!) {
                message.offline_file = File('images/fest.png');
              }
              if (message.type == 2) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return video_display4(
                      message.insert!, message.offline_file!, message.photo!);
                }));
              }
              if (message.type == 1) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return image_display(
                      message.insert!, message.offline_file!, message.photo!);
                }));
              }
            },
            child: message.type == 1
                ? _imageMessage(message)
                : message.type == 2
                    ? _videoMessage(message)
                    : _pdf_Message(message));
  }

  _textMessage(MessageModel message) {
    var width = MediaQuery.of(context).size.width;
    return widget.app_user.email == message.sender!
        ? Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                  topLeft: Radius.circular(11)),
              color: Colors.indigo[900],
            ),
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(9),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.text!,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  (!message.sent!)
                      ? const Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 14,
                              )
                            ])
                      : Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            message.seen == false
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueGrey,
                                    size: 14,
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 14,
                                  )
                          ],
                        )
                ],
              ),
            ))
        : Container(
            constraints: BoxConstraints(
              maxWidth: width - 80,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                  topRight: Radius.circular(11)),
              color: Colors.grey[400],
            ),
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(9),
            child: Text(
              message.text!,
              softWrap: true,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ));
  }

  _imageMessage(MessageModel message) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.currentmessage.sender! == widget.app_user.email
              ? Colors.indigo[900]
              : Colors.grey[400]),
      child: Column(
        children: [
          Center(
            child: Container(
                padding: EdgeInsets.all(13),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[50],
                    image: message.insert!
                        ? DecorationImage(
                            image: FileImage(message.offline_file!),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(message.photo!),
                            fit: BoxFit.cover))),
          ),
          Text(message.text!,
              style: TextStyle(
                  color: widget.currentmessage.sender! == widget.app_user.email
                      ? Colors.white
                      : Colors.black)),
          widget.currentmessage.sender! == widget.app_user.email
              ? Container(
                  child: (!widget.currentmessage.sent!)
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 14,
                              )
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            message.seen == false
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueGrey,
                                    size: 14,
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                            Container(width: 3)
                          ],
                        ))
              : Container()
        ],
      ),
    );
  }

  _videoMessage(MessageModel message) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.currentmessage.sender! == widget.app_user.email
              ? Colors.indigo[900]
              : Colors.grey[400]),
      child: Column(
        children: [
          Container(
            height: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child: Stack(
              children: <Widget>[
                _showController == true
                    ? Center(
                        child: InkWell(
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.blue,
                          size: 60,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return video_display4(message.insert!,
                                message.offline_file!, message.photo!);
                          }));
                        },
                      ))
                    : Container(),
                // Here you can also add Overlay capacities
              ],
            ),
          ),
          Text(message.text!,
              style: TextStyle(
                  color: widget.currentmessage.sender! == widget.app_user.email
                      ? Colors.white
                      : Colors.black)),
          widget.currentmessage.sender == widget.app_user.email
              ? Container(
                  child: (!widget.currentmessage.sent!)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                              Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 14,
                              )
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            message.seen == false
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueGrey,
                                    size: 14,
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                            Container(width: 3)
                          ],
                        ))
              : Container()
        ],
      ),
    );
  }

  _pdf_Message(MessageModel message) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            if (message.insert!) {
              return pdfviewer(message.offline_file!);
            } else {
              return pdfviewer1(message.photo!, true);
            }
          }));
        },
        child: Container(
          width: 200,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.currentmessage.sender! == widget.app_user.email
                  ? Colors.indigo[900]
                  : Colors.grey[400]),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(3),
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage("images/Explorer.png"),
                          fit: BoxFit.cover)),
                ),
              ),
              Text(message.text!,
                  style: TextStyle(
                      color:
                          widget.currentmessage.sender! == widget.app_user.email
                              ? Colors.white
                              : Colors.black)),
              widget.currentmessage.sender! == widget.app_user.email
                  ? Container(
                      child: (!widget.currentmessage.sent!)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                  Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                message.seen == false
                                    ? const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.blueGrey,
                                        size: 14,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                Container(width: 3)
                              ],
                            ))
                  : Container()
            ],
          ),
        ));
  }
}
