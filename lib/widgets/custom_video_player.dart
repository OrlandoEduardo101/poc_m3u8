import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/video_controller.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Offset? _startPanPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoController>(
      builder: (context, videoController, _) {
        if (videoController.isMinimized) {
          _animationController.reverse();
          // Em vez de remover, esconde o player mas mantém o vídeo rodando
          return Positioned(
            left: -1000, // Move para fora da tela
            top: -1000,
            child: SizedBox(
              width: 1,
              height: 1,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: videoController.playerController!,
                  ),
                ),
              ),
            ),
          );
        }
        
        final controller = videoController.playerController;
        if (!videoController.isInitialized || controller == null) {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Verifica se o controlador ainda está válido
        try {
          controller.videoPlayerController?.value;
        } catch (e) {
          print('Controller disposed, rebuilding...');
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Inicia a animação quando o player principal aparece
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!videoController.isMinimized) {
            _animationController.forward();
          }
        });

        return FadeTransition(
          opacity: _fadeAnimation,
          child: AspectRatio(
            aspectRatio: controller.videoPlayerController!.value.aspectRatio == 0
                ? 16 / 9
                : controller.videoPlayerController!.value.aspectRatio,
            child: Stack(
            fit: StackFit.expand,
            children: [
              BetterPlayer(
                controller: controller,
              ),
              // Gesto de swipe diagonal para minimizar
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) {
                  _startPanPosition = details.globalPosition;
                  _isDragging = false;
                },
                onPanUpdate: (details) {
                  if (_startPanPosition == null || _isDragging) return;
                  
                  final delta = details.globalPosition - _startPanPosition!;
                  final distance = delta.distance;
                  
                  // Detecta movimento diagonal (para baixo e para a direita)
                  if (distance > 80) {
                    final dx = delta.dx;
                    final dy = delta.dy;
                    
                    // Verifica se é movimento diagonal para baixo-direita
                    if (dx > 30 && dy > 30) {
                      _isDragging = true;
                      videoController.setMinimized(true);
                    }
                  }
                },
                onPanEnd: (details) {
                  _startPanPosition = null;
                  _isDragging = false;
                },
                child: const SizedBox.expand(),
              ),
              // Double-tap zones
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () => videoController.seekRelative(const Duration(seconds: -10)),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () => videoController.seekRelative(const Duration(seconds: 10)),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.hd),
                      color: Colors.white,
                      onPressed: () async {
                        final selected = await showModalBottomSheet<BetterPlayerAsmsTrack?>(
                          context: context,
                          builder: (_) => _QualitySheet(),
                        );
                        if (selected != null) {
                          videoController.setQualityTrack(selected);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.minimize),
                      color: Colors.white,
                      onPressed: () => videoController.setMinimized(true),
                    ),
                  ],
                ),
              ),
              // Indicador visual de gesto
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Arraste diagonalmente para minimizar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }
}

class _QualitySheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tracks = context.read<VideoController>().tracks;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Auto'),
            onTap: () => Navigator.of(context).pop(null),
          ),
          for (final t in tracks)
            ListTile(
              title: Text('${t.height}p • ${(t.bitrate ?? 0) ~/ 1000} kbps'),
              onTap: () => Navigator.of(context).pop(t),
            ),
        ],
      ),
    );
  }
}


