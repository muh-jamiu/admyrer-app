import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class StartVid extends StatefulWidget {
  @override
  _StartVidState createState() => _StartVidState();
}

class _StartVidState extends State<StartVid> {
  final String appId = 'b76f67d420d2486699d05d28cf678251';
  final String token = '007eJxTYJCfmRgfvnLRyW/WP/N6LsTpMLzkcSgOP/grQW8zX156rowCQ5K5WZqZeYqJkUGKkYmFmZmlZYqBaYqRRTJQ1MLI1HBrS1laQyAjw7+lqsyMDBAI4rMw5CZm5jEwAAAFVR5T';
  final String channelId = 'main';
  late RtcEngine _engine = createAgoraRtcEngine();
  int _remoteUid = 0;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
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
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Agora Video Call'),
        ),
        body:  Stack(
      children: [
        LocalVideoWidget(engine: _engine, localUserJoined: _localUserJoined),
        RemoteVideoWidget(engine: _engine, remoteUid: _remoteUid),
        _toolbar(),
      ],
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
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine,
          canvas: const VideoCanvas(uid: 0),
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
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: const RtcConnection(channelId: 'test'),
        ),
      );
    } else {
      return const Center(child: Text('Waiting for remote user to join...'));
    }
  }
}
