
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  late RtcEngine _engine;

  Future<void> initialize(String appId) async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));

    await _engine.enableVideo();
    await _engine.startPreview();
  }

  RtcEngine get engine => _engine;
}