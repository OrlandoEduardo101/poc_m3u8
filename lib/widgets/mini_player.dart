import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/video_controller.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoController>(
      builder: (context, vc, _) {
        if (!vc.isInitialized || !vc.isMinimized) return const SizedBox.shrink();
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 72,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => vc.setMinimized(false),
                  child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reproduzindo stream HLS',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(vc.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  onPressed: vc.togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => vc.setMinimized(false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


