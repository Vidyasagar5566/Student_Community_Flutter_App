import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testing_app/Files_disply_download/pdf_videos_images.dart';
import 'messanger.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';

class single_message extends StatefulWidget {
  Username app_user;
  Messager message;
  SmallUsername message_user;
  single_message(this.message, this.app_user, this.message_user);

  @override
  State<single_message> createState() => _single_messageState();
}

class _single_messageState extends State<single_message> {
  bool _showController = true;

  @override
  Widget build(BuildContext context) {
    Messager message = widget.message;
    return widget.app_user.email == message.messageSender
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

  _buildScreen(Messager message) {
    return message.messagFileType == '0'
        ? _textMessage(message)
        : GestureDetector(
            onTap: () {
              if (!message.insertMessage!) {
                message.file = File('images/fest.png');
              }
              if (message.messagFileType == '2') {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return video_display4(message.insertMessage!, message.file!,
                      message.messageFile!);
                }));
              }
              if (message.messagFileType == '1') {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return image_display(message.insertMessage!, message.file!,
                      message.messageFile!);
                }));
              }
            },
            child: message.messagFileType == '1'
                ? _imageMessage(message)
                : message.messagFileType == '2'
                    ? _videoMessage(message)
                    : _pdf_Message(message));
  }

  _textMessage(Messager message) {
    var width = MediaQuery.of(context).size.width;
    return widget.app_user.email == message.messageSender!
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
                        message.insertMessage!
                            ? message.messageBody!
                            : utf8convert(message.messageBody!),
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  (!widget.message.messageSent!)
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
                            message.messageSeen == false
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
              utf8convert(message.messageBody!),
              softWrap: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ));
  }

  _imageMessage(Messager message) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.message.messageSender! == widget.app_user.email
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
                    image: message.insertMessage!
                        ? DecorationImage(
                            image: FileImage(message.file!), fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(message.messageFile!),
                            fit: BoxFit.cover))),
          ),
          message.insertMessage!
              ? Text(message.messageBody!,
                  style: TextStyle(
                      color:
                          widget.message.messageSender! == widget.app_user.email
                              ? Colors.white
                              : Colors.black))
              : Text(utf8convert(message.messageBody!),
                  style: TextStyle(
                      color:
                          widget.message.messageSender! == widget.app_user.email
                              ? Colors.white
                              : Colors.black)),
          widget.message.messageSender! == widget.app_user.email
              ? Container(
                  child: (!widget.message.messageSent!)
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
                            message.messageSeen == false
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

  _videoMessage(Messager message) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.message.messageSender! == widget.app_user.email
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
                            return video_display4(message.insertMessage!,
                                message.file!, message.messageFile!);
                          }));
                        },
                      ))
                    : Container(),
                // Here you can also add Overlay capacities
              ],
            ),
          ),
          message.insertMessage!
              ? Text(message.messageBody!,
                  style: TextStyle(
                      color:
                          widget.message.messageSender! == widget.app_user.email
                              ? Colors.white
                              : Colors.black))
              : Text(utf8convert(message.messageBody!),
                  style: TextStyle(
                      color:
                          widget.message.messageSender! == widget.app_user.email
                              ? Colors.white
                              : Colors.black)),
          widget.message.messageSender == widget.app_user.email
              ? Container(
                  child: (!widget.message.messageSent!)
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
                            message.messageSeen == false
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

  _pdf_Message(Messager message) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            if (!message.insertMessage!) {
              return pdfviewer(message.file!);
            } else {
              return pdfviewer1(message.messageFile!, true);
            }
          }));
        },
        child: Container(
          width: 200,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.message.messageSender! == widget.app_user.email
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
              message.insertMessage!
                  ? Text(message.messageBody!,
                      style: TextStyle(
                          color: widget.message.messageSender! ==
                                  widget.app_user.email
                              ? Colors.white
                              : Colors.black))
                  : Text(utf8convert(message.messageBody!),
                      style: TextStyle(
                          color: widget.message.messageSender! ==
                                  widget.app_user.email
                              ? Colors.white
                              : Colors.black)),
              widget.message.messageSender! == widget.app_user.email
                  ? Container(
                      child: (!widget.message.messageSent!)
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
                                message.messageSeen == false
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
