import 'package:flutter/material.dart';
import '../video_player_provider.dart';
import 'shared_video_player.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Offset? _startPanPosition;
  bool _isDragging = false;

  void _handleSwipeUp() {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
    videoController.setMinimized(false);
  }

  @override
  Widget build(BuildContext context) {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;

    return ValueListenableBuilder(
      valueListenable: videoController.state,
      builder: (context, videoState, child) {
        if (!videoState.isMinimized || !videoState.isInitialized) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 16,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
              videoController.setMinimized(false);
            },
            onPanStart: (details) {
              _startPanPosition = details.globalPosition;
              _isDragging = false;
            },
            onPanUpdate: (details) {
              if (_startPanPosition == null || _isDragging) return;

              final delta = details.globalPosition - _startPanPosition!;
              final distance = delta.distance;

              if (distance > 60) {
                final dx = delta.dx;
                final dy = delta.dy;

                // Swipe up and left to restore
                if (dx < -20 && dy < -20) {
                  _isDragging = true;
                  _handleSwipeUp();
                }
              }
            },
            onPanEnd: (details) {
              _startPanPosition = null;
              _isDragging = false;
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Mini video preview - usando Flexible para permitir redimensionamento
                    Flexible(
                      flex: 0,
                      child: Container(
                        width: 120,
                        height: 68,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        child: videoState.playerConfig != null
                            ? IgnorePointer(
                                child: SharedVideoPlayerWidget(config: videoState.playerConfig!, isMinimized: true),
                              )
                            : const Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            videoState.currentVideoTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Tocando agora...',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: Icon(videoState.isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
                          videoController.setPlaying(!videoState.isPlaying);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
                          videoController.setMinimized(false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
