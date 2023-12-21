import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import '/User_profile/Models.dart';
import 'package:video_player/video_player.dart';

class pdfviewer1 extends StatefulWidget {
  String pdf_url;
  bool yes_no;
  pdfviewer1(this.pdf_url, this.yes_no);

  @override
  State<pdfviewer1> createState() => _pdfviewer1State();
}

class _pdfviewer1State extends State<pdfviewer1> {
  PDFViewController? pdfViewController;
  late File Pfile;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.pdf_url;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = "testing1234567"; //basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadNetwork();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + "/"; //+ Platform.pathSeparator + 'Download';
    }
  }

  String pagenum = "1";
  String totalpage = "";
  bool downloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter PDF Viewer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Text((pagenum) + "/" + totalpage),
          const SizedBox(width: 10),
          (widget.yes_no)
              ? ((ret == "" || ret == "failed")
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          ret = "start";
                        });
                        bool _permissionReady = await _checkPermission();
                        if (_permissionReady) {
                          await _prepareSaveDir();
                          print("Downloading");
                          try {
                            List<String> urls = widget.pdf_url.split('?');
                            List<String> sub_urls = urls[0].split("/");
                            print(_localPath);
                            final Response response = await Dio().download(
                                widget.pdf_url,
                                _localPath + sub_urls[sub_urls.length - 1]);
                            print(response.data);
                            setState(() {
                              ret = "";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Platform.isAndroid
                                    ? const Text(
                                        'success, check your download folder',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        'success, check your ESMUS folder in your "on my iphone"',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              ret = "failed";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'failed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue),
                    )
                  : const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(color: Colors.blue)))
              : Container()
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                    filePath: Pfile.path,
                    autoSpacing: true,
                    enableSwipe: true,
                    pageSnap: true,
                    onError: (error) {
                      print(error);
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController vc) {
                      pdfViewController = vc;
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        pagenum = page.toString();
                        totalpage = total.toString();
                      });
                    }),
              ),
            ),
    );
  }
}

class pdfviewer extends StatefulWidget {
  File pdf;
  pdfviewer(this.pdf);

  @override
  State<pdfviewer> createState() => _pdfviewerState();
}

class _pdfviewerState extends State<pdfviewer> {
  PDFViewController? pdfViewController;

  @override
  Widget build(BuildContext context) {
    String name = basename(widget.pdf.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: PDFView(
          filePath: widget.pdf.path,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          onError: (error) {
            print(error);
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController vc) {
            pdfViewController = vc;
          },
          onPageChanged: (page, total) {
            print('page change: $page/$total');
          }),
    );
  }
}

class video_display extends StatefulWidget {
  String url;
  video_display(this.url);

  @override
  State<video_display> createState() => _video_displayState();
}

class _video_displayState extends State<video_display> {
  VideoPlayerController? _videoPlayerController;
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _videoPlayerController = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          actions: [
            Container(
              child: (ret == "" || ret == "failed")
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          ret = "start";
                        });
                        bool _permissionReady = await _checkPermission();
                        if (_permissionReady) {
                          await _prepareSaveDir();
                          print("Downloading");
                          try {
                            List<String> urls = widget.url.split('?');
                            List<String> sub_urls = urls[0].split("/");
                            await Dio().download(widget.url,
                                _localPath + sub_urls[sub_urls.length - 1]);
                            setState(() {
                              ret = "";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'success',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              ret = "failed";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'failed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.white),
                    )
                  : const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(color: Colors.white)),
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_videoPlayerController!),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              _videoPlayerController!.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                _videoPlayerController!.value.isPlaying
                                    ? _videoPlayerController!.pause()
                                    : _videoPlayerController!.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      _videoPlayerController!,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.pause();
  }
}

class video_display1 extends StatefulWidget {
  File file;
  video_display1(this.file);

  @override
  State<video_display1> createState() => _video_display1State();
}

class _video_display1State extends State<video_display1> {
  VideoPlayerController? _videoPlayerController;
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _videoPlayerController = VideoPlayerController.file(widget.file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_videoPlayerController!),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              _videoPlayerController!.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                _videoPlayerController!.value.isPlaying
                                    ? _videoPlayerController!.pause()
                                    : _videoPlayerController!.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      _videoPlayerController!,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.pause();
  }
}

class video_display3 extends StatefulWidget {
  String url;
  VideoPlayerController _videoPlayerController;
  video_display3(this.url, this._videoPlayerController);

  @override
  State<video_display3> createState() => _video_display3State();
}

class _video_display3State extends State<video_display3> {
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";

  @override
  void initState() {
    super.initState();
    widget._videoPlayerController.play();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/"; //NITC ESMUS/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + "/"; //+ Platform.pathSeparator + 'Download/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          actions: [
            (ret == "" || ret == "failed")
                ? IconButton(
                    onPressed: () async {
                      setState(() {
                        ret = "start";
                      });
                      bool _permissionReady = await _checkPermission();
                      if (_permissionReady) {
                        await _prepareSaveDir();
                        print("Downloading");
                        try {
                          List<String> urls = widget.url.split('?');
                          List<String> sub_urls = urls[0].split("/");
                          print(_localPath);
                          final Response response = await Dio().download(
                              widget.url,
                              _localPath + sub_urls[sub_urls.length - 1]);
                          print(response.data);
                          setState(() {
                            ret = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Platform.isAndroid
                                  ? const Text(
                                      'success, check your download folder',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const Text(
                                      'success, check your ESMUS folder in your "on my iphone"',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            ret = "failed";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'failed',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon:
                        const Icon(Icons.download_rounded, color: Colors.white),
                  )
                : const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(color: Colors.white))
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: widget._videoPlayerController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(widget._videoPlayerController),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              widget._videoPlayerController.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                widget._videoPlayerController.value.isPlaying
                                    ? widget._videoPlayerController.pause()
                                    : widget._videoPlayerController.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      widget._videoPlayerController,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    widget._videoPlayerController.pause();
  }
}

class video_display4 extends StatefulWidget {
  bool insert;
  File file;
  String url;
  video_display4(this.insert, this.file, this.url);

  @override
  State<video_display4> createState() => _video_display4State();
}

class _video_display4State extends State<video_display4> {
  VideoPlayerController? _videoPlayerController;
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    if (widget.insert) {
      _videoPlayerController = VideoPlayerController.file(widget.file,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    }

    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          actions: [
            !widget.insert
                ? Container(
                    child: (ret == "" || ret == "failed")
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                ret = "start";
                              });
                              bool _permissionReady = await _checkPermission();
                              if (_permissionReady) {
                                await _prepareSaveDir();
                                print("Downloading");
                                try {
                                  List<String> urls = widget.url.split('?');
                                  List<String> sub_urls = urls[0].split("/");
                                  await Dio().download(
                                      widget.url,
                                      _localPath +
                                          sub_urls[sub_urls.length - 1]);
                                  setState(() {
                                    ret = "";
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'success',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() {
                                    ret = "failed";
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'failed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.download_rounded,
                                color: Colors.white),
                          )
                        : const SizedBox(
                            height: 12,
                            width: 12,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                  )
                : Container()
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_videoPlayerController!),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              _videoPlayerController!.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                _videoPlayerController!.value.isPlaying
                                    ? _videoPlayerController!.pause()
                                    : _videoPlayerController!.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      _videoPlayerController!,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.pause();
  }
}

class image_display extends StatefulWidget {
  bool insert;
  File file;
  String url;
  image_display(this.insert, this.file, this.url);

  @override
  State<image_display> createState() => _image_displayState();
}

class _image_displayState extends State<image_display> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          height: height,
          width: width,
          color: Colors.black,
          child: Center(
              child: !widget.insert
                  ? Image(image: NetworkImage(widget.url))
                  : Image(image: FileImage(widget.file))),
        ));
  }
}

class all_files_display extends StatefulWidget {
  Username app_user;
  double file_type1;
  String file1;
  all_files_display(this.app_user, this.file_type1, this.file1);

  @override
  State<all_files_display> createState() => _all_files_displayState();
}

class _all_files_displayState extends State<all_files_display> {
  bool _showController = true;
  @override
  Widget build(BuildContext context) {
    String file = widget.file1;
    double file_type = widget.file_type1;
    return GestureDetector(
      onTap: () {
        if (file_type == 2) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return video_display(file);
          }));
        }
        if (file_type == 1) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return image_display(false, File('images/club.jpg'), file);
          }));
        }
      },
      child: file_type == 0
          ? Container()
          : file_type == 1
              ? Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.indigo[900]),
                  child: Container(
                      padding: EdgeInsets.all(13),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[50],
                          image: DecorationImage(
                              image: NetworkImage(file), fit: BoxFit.cover))),
                )
              : file_type == 2
                  ? Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo[900]),
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            ClosedCaption(text: null),
                            _showController == true
                                ? Center(
                                    child: InkWell(
                                    child: const Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return video_display(file);
                                      }));
                                    },
                                  ))
                                : Container(),
                            // Here you can also add Overlay capacities
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return pdfviewer1(file, true);
                        }));
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo[900]),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage("images/Explorer.png"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      )),
    );
  }
}

class all_files_display1 extends StatefulWidget {
  Username app_user;
  double file_type1;
  File file1;
  all_files_display1(this.app_user, this.file_type1, this.file1);

  @override
  State<all_files_display1> createState() => _all_files_display1State();
}

class _all_files_display1State extends State<all_files_display1> {
  bool _showController = true;
  @override
  Widget build(BuildContext context) {
    File file = widget.file1;
    double file_type = widget.file_type1;
    return GestureDetector(
      onTap: () {
        if (file_type == 2) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return video_display1(file);
          }));
        }
        if (file_type == 1) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return image_display(true, file, "");
          }));
        }
      },
      child: file_type == 0
          ? Container()
          : file_type == 1
              ? Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.indigo[900]),
                  child: Container(
                      padding: EdgeInsets.all(13),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[50],
                          image: DecorationImage(
                              image: FileImage(file), fit: BoxFit.cover))),
                )
              : file_type == 2
                  ? Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo[900]),
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            ClosedCaption(text: null),
                            _showController == true
                                ? Center(
                                    child: InkWell(
                                    child: const Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return video_display1(file);
                                      }));
                                    },
                                  ))
                                : Container(),
                            // Here you can also add Overlay capacities
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return pdfviewer(file);
                        }));
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo[900]),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage("images/Explorer.png"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      )),
    );
  }
}
