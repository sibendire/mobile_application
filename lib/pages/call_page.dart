import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_service.dart';

class CallPage extends StatefulWidget {
  final String channelId;

  const CallPage({super.key, required this.channelId});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  int? remoteUid;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await AgoraService().initialize('YOUR_AGORA_APP_ID');

    AgoraService().engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("Joined channel");
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() => remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => remoteUid = null);
        },
      ),
    );

    await AgoraService().engine.joinChannel(
      token: "",
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    AgoraService().engine.leaveChannel();
    AgoraService().engine.release();
    super.dispose();
  }

  Widget _remoteVideo() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: AgoraService().engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Center(child: Text("Waiting for user..."));
    }
  }

  Widget _localPreview() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 120,
        height: 160,
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: AgoraService().engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Call"),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          _remoteVideo(),
          _localPreview(),
        ],
      ),
    );
  }
}