import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/video_controller.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Offset? _startPanPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
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
      builder: (context, vc, _) {
        if (!vc.isInitialized || !vc.isMinimized) {
          _animationController.reverse();
          return const SizedBox.shrink();
        }
        
        final controller = vc.playerController;
        if (controller == null || !vc.isInitialized) return const SizedBox.shrink();
        
        // Verifica se o controlador ainda está válido
        try {
          controller.videoPlayerController?.value;
        } catch (e) {
          print('Controller disposed, rebuilding...');
          return const SizedBox.shrink();
        }
        
        // Inicia a animação quando o miniplayer aparece
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vc.isMinimized) {
            _animationController.forward();
          }
        });
        
        return SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 96,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: GestureDetector(
                onPanStart: (details) {
                  _startPanPosition = details.globalPosition;
                  _isDragging = false;
                },
                onPanUpdate: (details) {
                  if (_startPanPosition == null || _isDragging) return;
                  
                  final delta = details.globalPosition - _startPanPosition!;
                  final distance = delta.distance;
                  
                  // Detecta movimento diagonal (para cima e para a esquerda)
                  if (distance > 80) {
                    final dx = delta.dx;
                    final dy = delta.dy;
                    
                    // Verifica se é movimento diagonal para cima-esquerda
                    if (dx < -30 && dy < -30) {
                      _isDragging = true;
                      vc.setMinimized(false);
                    }
                  }
                },
                onPanEnd: (details) {
                  _startPanPosition = null;
                  _isDragging = false;
                },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => vc.setMinimized(false),
                      child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    // Thumbnail video view - apenas visual, sem nova instância
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 160,
                        height: 90,
                        color: Colors.black,
                        child: Stack(
                          children: [
                            // Background com cor sólida ou thumbnail se disponível
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade800,
                                    Colors.purple.shade800,
                                  ],
                                ),
                              ),
                            ),
                            // Overlay com informações do vídeo
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'HLS Stream',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Reproduzindo stream HLS',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Arraste diagonalmente para restaurar',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
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
            ),
          ),
        );
      },
    );
  }
}


