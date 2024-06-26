import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';

class SpeedDate extends StatefulWidget {
  final String username;
  final String avatar;
  const SpeedDate({super.key, required this.username, required this.avatar});
  @override
  _SpeedDateState createState() => _SpeedDateState();
}

class _SpeedDateState extends State<SpeedDate> {
  final String appId = 'b76f67d420d2486699d05d28cf678251';
  late String channelId = widget.username;
  late RtcEngine _engine = createAgoraRtcEngine();
  int _remoteUid = 0;
  bool _localUserJoined = false;
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  String token = "";
  bool _isMuted = false;
  bool _isVideoMuted = false;
  bool _remoteAudioMuted = false;
  bool _remoteVideoMuted = false;

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
          showErrorToast("Call ID: $uid");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showErrorToast("User join with ID: $remoteUid");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showErrorToast("User left with ID: $remoteUid");
          setState(() {
            _remoteUid = 0;
          });
        },
        onUserMuteAudio: (RtcConnection connection, int remoteUid,
            bool value) {
         setState(() {
          _remoteAudioMuted = value;
        });
        },
      onUserMuteVideo: (RtcConnection connection, int remoteUid,
            bool value){
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
                _topBar(),
                LocalVideoWidget(
                    engine: _engine, localUserJoined: _localUserJoined, isCam: _isVideoMuted, isRemote: _remoteUid),
                RemoteVideoWidget(engine: _engine, remoteUid: _remoteUid, isCam: _remoteVideoMuted, channelId: channelId),
                _toolbar(),
              ],
            ),
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
          child: Text("Speed Date", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
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
          ],
        ),
      ),
    );
  }
}

class LocalVideoWidget extends StatefulWidget {
  final RtcEngine engine;
  final bool localUserJoined;
  final int isRemote;
  final bool isCam;

  LocalVideoWidget({required this.engine, required this.localUserJoined, required this.isCam, required this.isRemote});

  @override
  State<LocalVideoWidget> createState() => _LocalVideoWidgetState();
}

class _LocalVideoWidgetState extends State<LocalVideoWidget> {
  @override
  Widget build(BuildContext context) {
    if(widget.isRemote == 0){
     if(widget.localUserJoined){
       if(widget.isCam){
        return const Center(child: Text('You turn off camera'));
      }else{
      return Align(
        alignment: Alignment.center,
        child:AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: widget.engine,
            canvas: VideoCanvas(uid: 0),
          ),
        ),
      );}
     }else{
      return const Center(child: CircularProgressIndicator());
     }
    }else{
    if (widget.localUserJoined) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Positioned(
        right: 16,
        top: 16,
        width: 120,
        height: 160,
        child: widget.isCam
            ? Container(
                color: Colors.black,
                child: const Center(child: Text('User turn off camera', style: TextStyle(color: Colors.white),)),
              )
            : AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: widget.engine,
                  canvas: VideoCanvas(uid: 0),
                ),
              ),
            ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10)
        ),
        child: const Positioned(
        right: 16,
        top: 16,
        width: 120,
        height: 160,
          child: Center(child: CircularProgressIndicator(color: Colors.white,))),
      )
        ;
    }}
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
        return const Center(child: Text('This user turn off their camera'));
      }else{
      return Align(
        alignment: Alignment.center,
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
