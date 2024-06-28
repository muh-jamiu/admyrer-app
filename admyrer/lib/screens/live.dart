import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';

class StartVid extends StatefulWidget {
  final String username;
  final String avatar;
  const StartVid({super.key, required this.username, required this.avatar});
  @override
  _StartVidState createState() => _StartVidState();
}

class _StartVidState extends State<StartVid> {
  final String appId = 'b76f67d420d2486699d05d28cf678251';
  String token = "";
  late String channelId = widget.username;
  late RtcEngine _engine = createAgoraRtcEngine();
  int _remoteUid = 0;
  bool _localUserJoined = false;
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  bool _isMuted = false;
  bool _isVideoMuted = false;
  bool _remoteAudioMuted = false;
  bool _remoteVideoMuted = false;
  var userId = 0;
  bool isSidebarVisible = false;
  String? _currentlyPlaying;

  final List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    'Song 4',
    'Song 5',
  ];


  Future<void> saveLive() async {
    try {
      final response = await _apiService.postRequest("live", {
        "username": widget.username,
        "channel": widget.username,
        "token": token,
        "avatar": widget.avatar,
      });

      var data = json.decode(response.body);
      var userId = data["data"];

      setState(() {
        this.userId = userId;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteLive() async {
    try {
      await _apiService.postRequest("delete-live", {
        "id": userId,
      });
    } catch (e) {
      print(e);
    }
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 178),
      fontSize: 15.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> getToken() async {
    try {
      final response = await _apiService.postRequest("token", {
        "channel": widget.username,
      });
      var data = json.decode(response.body);
      String token = data["data"];

      setState(() {
        this.token = token;
        isLoading = false;
      });
      saveLive();
    } catch (e) {
      showErrorToast('An error occurred: $e');
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initAgora() async {
    await getToken();

    // Request camera and microphone permissions
    await [Permission.camera, Permission.microphone].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableVideo();
    await _engine.startPreview(); 

    // Set event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int uid) {
          showErrorToast("You start video call with ID: $uid");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showErrorToast("User with ID: $remoteUid join video call");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showErrorToast("User with ID: $remoteUid left video call");
          setState(() {
            _remoteUid = 0;
          });
        },
        onUserMuteAudio: (RtcConnection connection, int remoteUid,
            bool value) {
          showErrorToast("User with ID: $remoteUid mute/unmute audio");
         setState(() {
          _remoteAudioMuted = value;
        });
        },
      onUserMuteVideo: (RtcConnection connection, int remoteUid,
            bool value){
          showErrorToast("User with ID: $remoteUid turn off/on camera");
        setState(() {
          _remoteVideoMuted = value;
        });
      },
      ),
    );

    // Join the channel
    await _engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  void _toggleVideoMute() {
    setState(() {
      _isVideoMuted = !_isVideoMuted;
    });
    _engine.muteLocalVideoStream(_isVideoMuted);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _switchCamera() {
    _engine.switchCamera();
  }

  void toggleSidebar() {
    setState(() {
      isSidebarVisible = !isSidebarVisible;
    });
  }

  void _playMusic(String track) {
    setState(() {
      _currentlyPlaying = track;
    });
    // Code to play music
  }

  void _pauseMusic() {
    setState(() {
      _currentlyPlaying = null;
    });
    // Code to pause music
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 255, 205, 214), Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 255, 205, 214), Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
              const SizedBox(height: 20,),
                _topBar(),
                LocalVideoWidget(
                    engine: _engine, localUserJoined: _localUserJoined, isCam: _isVideoMuted,),
                RemoteVideoWidget(engine: _engine, remoteUid: _remoteUid, isCam: _remoteVideoMuted, channelId: channelId),
                _toolbar(),
              _song(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _song(BuildContext context) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        left: isSidebarVisible ? 0 : -250,
        top: 0,
        bottom: 0,
        child: Material(
          elevation: 8,
          child: Container(
            width: 250,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                const Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Songs List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                    String track = songs[index];
                    bool isPlaying = _currentlyPlaying == track;
                      if(songs.length == 0){
                        return const Center(
                          child: Column(children: [
                            Text("Empty", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                            Text("There are no uploaded music at the moment",style: TextStyle(fontSize: 18),),
                          ],),
                        );
                      }else{
                      return ListTile(
                        title: Text(songs[index]),
                        trailing: IconButton(
                          icon:Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.red,),
                          onPressed: () {
                             if (isPlaying) {
                                _pauseMusic();
                              } else {
                                _playMusic(track);
                              }
                          },
                        ),
                      );}
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }


  Widget _topBar() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Row(children: [
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Text("Live Stream", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
        )
      ],),
    );}

  Widget _toolbar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: _toggleMute,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: _isMuted ? Colors.pink[400] : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _isMuted ? Icons.mic_off : Icons.mic,
                color: _isMuted ? Colors.white : Colors.pink[400],
                size: 20.0,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              onPressed: () {
                _engine.leaveChannel();
                Navigator.pop(context);
                deleteLive();
              },
            ),
            RawMaterialButton(
              onPressed: _toggleVideoMute,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: _isVideoMuted ? Colors.pink[400] : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _isVideoMuted ? Icons.videocam_off : Icons.videocam,
                color: _isVideoMuted ? Colors.white : Colors.pink[400],
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _switchCamera,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.switch_camera,
                color: Colors.pink[400],
                size: 20.0,
              ),
            ),
             RawMaterialButton(
              onPressed: toggleSidebar,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.music_note,
                color: Colors.purple[400],
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocalVideoWidget extends StatefulWidget {
  final RtcEngine engine;
  final bool localUserJoined;
  final bool isCam;

  LocalVideoWidget({required this.engine, required this.localUserJoined, required this.isCam});

  @override
  State<LocalVideoWidget> createState() => _LocalVideoWidgetState();
}

class _LocalVideoWidgetState extends State<LocalVideoWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.localUserJoined) {
      if(widget.isCam){
        return const Center(child: Text('You turn off camera'));
      } else{
      return Align(
        alignment: Alignment.topLeft,
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: widget.engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );}
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class RemoteVideoWidget extends StatefulWidget {
  final RtcEngine engine;
  final int remoteUid;
  final bool isCam;
  final String channelId;

  RemoteVideoWidget({required this.engine, required this.remoteUid, required this.isCam, required this.channelId});

  @override
  State<RemoteVideoWidget> createState() => _RemoteVideoWidgetState();
}

class _RemoteVideoWidgetState extends State<RemoteVideoWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.remoteUid != 0) {
      if(widget.isCam){
        return const Center(child: Text('This user turn of their camera'));
      }else{
      return Align(
        alignment: Alignment.topRight,
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: widget.engine,
            canvas: VideoCanvas(uid: widget.remoteUid),
            connection: RtcConnection(channelId: widget.channelId),
          ),
        ),
      );}
    } else {
      return const Center(child: Text('Waiting for other user to join...'));
    }
  }
}

