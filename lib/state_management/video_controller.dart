import 'package:flutter/material.dart';
import 'package:m3u8_player_plus/m3u8_player_plus.dart';

class VideoState {
  final PlayerConfig? playerConfig;
  final bool isMinimized;
  final bool isInitialized;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isFullscreen;
  final String currentVideoTitle;

  const VideoState({
    this.playerConfig,
    this.isMinimized = false,
    this.isInitialized = false,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isFullscreen = false,
    this.currentVideoTitle = 'Stream HLS',
  });

  VideoState copyWith({
    PlayerConfig? playerConfig,
    bool? isMinimized,
    bool? isInitialized,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isFullscreen,
    String? currentVideoTitle,
  }) {
    return VideoState(
      playerConfig: playerConfig ?? this.playerConfig,
      isMinimized: isMinimized ?? this.isMinimized,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      currentVideoTitle: currentVideoTitle ?? this.currentVideoTitle,
    );
  }
}

class VideoController {
  final ValueNotifier<VideoState> _state = ValueNotifier(const VideoState());
  String hlsUrl;

  VideoController({required this.hlsUrl}) {
    _initializePlayer();
  }

  // Getters
  ValueNotifier<VideoState> get state => _state;
  VideoState get currentState => _state.value;

  void _initializePlayer() {
    try {
      final playerConfig = PlayerConfig(
        url: hlsUrl,
        autoPlay: true,
        loop: false,
        startPosition: 0,
        enableProgressCallback: true,
        progressCallbackInterval: 1,
        onProgressUpdate: (position) {
          _updateState(_state.value.copyWith(position: position));
        },
        onFullscreenChanged: (isFullscreen) {
          _updateState(_state.value.copyWith(isFullscreen: isFullscreen));
        },
        completedPercentage: 0.95,
        onCompleted: () {
          debugPrint('Vídeo completo');
        },
        theme: PlayerTheme(
          primaryColor: Colors.blue,
          backgroundColor: Colors.black,
          bufferColor: Colors.grey,
          progressColor: Colors.red,
          iconSize: 24.0,
        ),
      );

      _updateState(
        _state.value.copyWith(
          playerConfig: playerConfig,
          isInitialized: true,
          isPlaying: true, // autoPlay is true
        ),
      );
    } catch (e) {
      debugPrint('Erro ao inicializar player: $e');
    }
  }

  void _updateState(VideoState newState) {
    _state.value = newState;
  }

  void setMinimized(bool isMinimized) {
    _updateState(_state.value.copyWith(isMinimized: isMinimized));
  }

  void setPlaying(bool isPlaying) {
    _updateState(_state.value.copyWith(isPlaying: isPlaying));
  }

  void updatePosition(Duration position) {
    _updateState(_state.value.copyWith(position: position));
  }

  void updateDuration(Duration duration) {
    _updateState(_state.value.copyWith(duration: duration));
  }

  // Recreate player config with new URL or settings
  void updatePlayerConfig({String? newUrl, bool? autoPlay, PlayerTheme? theme, String? videoTitle}) {
    final currentConfig = _state.value.playerConfig;
    if (currentConfig != null) {
      final newPlayerConfig = PlayerConfig(
        url: newUrl ?? hlsUrl,
        autoPlay: autoPlay ?? currentConfig.autoPlay,
        loop: currentConfig.loop,
        startPosition: currentConfig.startPosition,
        enableProgressCallback: currentConfig.enableProgressCallback,
        progressCallbackInterval: currentConfig.progressCallbackInterval,
        onProgressUpdate: currentConfig.onProgressUpdate,
        onFullscreenChanged: currentConfig.onFullscreenChanged,
        completedPercentage: currentConfig.completedPercentage,
        onCompleted: currentConfig.onCompleted,
        theme: theme ?? currentConfig.theme,
      );

      if (newUrl != null) {
        hlsUrl = newUrl;
      }

      _updateState(_state.value.copyWith(playerConfig: newPlayerConfig, currentVideoTitle: videoTitle));
    }
  }

  void dispose() {
    _state.dispose();
  }
}
