import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';

class StartVid extends StatefulWidget {
  @override
  _StartVidState createState() => _StartVidState();
}

class _StartVidState extends State<StartVid> {
  final String appId = 'b76f67d420d2486699d05d28cf678251';
  // final String token =
  //     '007eJxTYMj8dcqtqobLlr9VccnPv3WPLePkDa7ndv9fwGehslqM20yBIcncLM3MPMXEyCDFyMTCzMzSMsXANMXIIhkoamFkavj8YHlaQyAjQ9MBIWZGBggE8VkYchMz8xgYANfMHac=';
  final String channelId = 'main';
  late RtcEngine _engine = createAgoraRtcEngine();
  int _remoteUid = 0;
  bool _localUserJoined = false;
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  String token = "";

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
      final response = await _apiService.getRequest("token");
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
          appBar: AppBar(
            title: Text('Live Stream'),
          ),
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
                LocalVideoWidget(
                    engine: _engine, localUserJoined: _localUserJoined),
                RemoteVideoWidget(engine: _engine, remoteUid: _remoteUid),
                _toolbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.red,
            onPressed: () {
              _engine.leaveChannel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class LocalVideoWidget extends StatelessWidget {
  final RtcEngine engine;
  final bool localUserJoined;

  LocalVideoWidget({required this.engine, required this.localUserJoined});

  @override
  Widget build(BuildContext context) {
    if (localUserJoined) {
      return Align(
        alignment: Alignment.topLeft,
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class RemoteVideoWidget extends StatelessWidget {
  final RtcEngine engine;
  final int remoteUid;

  RemoteVideoWidget({required this.engine, required this.remoteUid});

  @override
  Widget build(BuildContext context) {
    if (remoteUid != 0) {
      return Align(
        alignment: Alignment.topRight,
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: engine,
            canvas: VideoCanvas(uid: remoteUid),
            connection: const RtcConnection(channelId: 'main'),
          ),
        ),
      );
    } else {
      return const Center(child: Text('Waiting for other user to join...'));
    }
  }
}
