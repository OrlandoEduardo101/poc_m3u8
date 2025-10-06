import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VideoController extends ChangeNotifier {
  VideoController({required this.hlsUrl});

  final String hlsUrl;

  BetterPlayerController? _playerController;
  BetterPlayerController? get playerController => _playerController;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isMinimized = false;
  bool get isMinimized => _isMinimized;

  List<BetterPlayerAsmsTrack> _tracks = <BetterPlayerAsmsTrack>[];
  List<BetterPlayerAsmsTrack> get tracks => List.unmodifiable(_tracks);

  void Function(BetterPlayerEvent event)? _eventListener;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      hlsUrl,
      useAsmsSubtitles: false,
      useAsmsTracks: true,
      liveStream: false,
      videoFormat: BetterPlayerVideoFormat.hls,
    );

    final config = BetterPlayerConfiguration(
      autoPlay: true,
      fit: BoxFit.contain,
      autoDetectFullscreenDeviceOrientation: true,
      expandToFill: false,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enablePip: true,
        enableQualities: true,
        enableOverflowMenu: true,
      ),
    );

    _playerController = BetterPlayerController(config);
    await _playerController!.setupDataSource(dataSource);

    _isInitialized = true;
    _isPlaying = _playerController!.isPlaying() ?? false;
    _tracks = _playerController!.betterPlayerAsmsTracks;

    _eventListener = (event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _isPlaying = true;
        notifyListeners();
      } else if (event.betterPlayerEventType == BetterPlayerEventType.pause ||
          event.betterPlayerEventType == BetterPlayerEventType.finished) {
        _isPlaying = false;
        notifyListeners();
      } else if (event.betterPlayerEventType == BetterPlayerEventType.setupDataSource) {
        _tracks = _playerController!.betterPlayerAsmsTracks;
        notifyListeners();
      }
    };
    _playerController!.addEventsListener(_eventListener!);

    notifyListeners();
  }

  void togglePlayPause() {
    if (_playerController == null) return;
    final isNowPlaying = _playerController!.isPlaying();
    if (isNowPlaying == true) {
      _playerController!.pause();
    } else {
      _playerController!.play();
    }
  }

  Future<void> seekRelative(Duration offset) async {
    if (_playerController == null) return;
    final position = _playerController!.videoPlayerController!.value.position;
    final target = position + offset;
    await _playerController!.seekTo(target < Duration.zero ? Duration.zero : target);
  }

  Future<void> setQualityTrack(BetterPlayerAsmsTrack track) async {
    if (_playerController == null) return;
    _playerController!.setTrack(track);
    _tracks = _playerController!.betterPlayerAsmsTracks;
    notifyListeners();
  }

  void enterPip() {
    // BetterPlayer handles PiP on supported platforms when enabled in configuration
    _playerController?.enablePictureInPicture(_playerController!.betterPlayerGlobalKey!);
  }

  void setMinimized(bool value) {
    if (_isMinimized == value) return;
    _isMinimized = value;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_eventListener != null && _playerController != null) {
      _playerController!.removeEventsListener(_eventListener!);
    }
    _playerController?.dispose();
    super.dispose();
  }
}


