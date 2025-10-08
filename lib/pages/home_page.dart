import 'package:flutter/material.dart';

import '../video_player_provider.dart';
import '../widgets/mini_player.dart';
import 'video_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Bem-vindo ao Player HLS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                'Este é um exemplo de como o player funciona com miniplayer e navegação.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text('Lista de Vídeos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, size: 48, color: Colors.red),
                  title: const Text('Vídeo Demo 1'),
                  subtitle: const Text('Exemplo de streaming HLS - Qualidade HD • 15:30'),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                      Text('HD', style: TextStyle(fontSize: 10, color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    _openVideoPlayer(
                      context,
                      'Vídeo Demo 1',
                      'https://vz-d6522dee-d49.b-cdn.net/9ee486e7-76c6-40bc-b810-b8882047cead/playlist.m3u8?video=1',
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, size: 48, color: Colors.blue),
                  title: const Text('Vídeo Demo 2'),
                  subtitle: const Text('Streaming de alta qualidade - Múltiplas resoluções • 22:45'),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                      Text('4K', style: TextStyle(fontSize: 10, color: Colors.blue)),
                    ],
                  ),
                  onTap: () {
                    _openVideoPlayer(
                      context,
                      'Vídeo Demo 2',
                      'https://vz-d6522dee-d49.b-cdn.net/9ee486e7-76c6-40bc-b810-b8882047cead/playlist.m3u8?video=2',
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, size: 48, color: Colors.green),
                  title: const Text('Vídeo Demo 3'),
                  subtitle: const Text('Conteúdo adaptativo HLS - Experiência premium • 08:12'),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                      Text('UHD', style: TextStyle(fontSize: 10, color: Colors.green)),
                    ],
                  ),
                  onTap: () {
                    _openVideoPlayer(
                      context,
                      'Vídeo Demo 3',
                      'https://vz-d6522dee-d49.b-cdn.net/9ee486e7-76c6-40bc-b810-b8882047cead/playlist.m3u8?video=3',
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline, size: 48),
                  title: const Text('Recursos do Player'),
                  subtitle: const Text('HLS, Qualidade, PiP, Miniplayer'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showFeaturesDialog(context);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.gesture, size: 48),
                  title: const Text('Como Usar'),
                  subtitle: const Text('Gestos e controles'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showInstructionsDialog(context);
                  },
                ),
              ),
              const SizedBox(height: 32),
              ValueListenableBuilder(
                valueListenable: VideoPlayerInheritedWidget.of(context)!.videoController.state,
                builder: (context, videoState, _) {
                  if (videoState.isMinimized) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Vídeo em reprodução',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'O vídeo está sendo reproduzido no miniplayer. Você pode continuar navegando pela home.',
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              _openVideoPlayer(
                                context,
                                'Vídeo atual',
                                'https://vz-d6522dee-d49.b-cdn.net/9ee486e7-76c6-40bc-b810-b8882047cead/playlist.m3u8',
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Voltar ao Player'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }

  void _openVideoPlayer(BuildContext context, String videoTitle, String videoUrl) {
    // Atualiza o controller com o novo vídeo
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
    videoController.updatePlayerConfig(newUrl: videoUrl, videoTitle: videoTitle);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(videoTitle: videoTitle, videoUrl: videoUrl),
      ),
    );
  }

  void _showFeaturesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recursos do Player'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Streaming HLS (.m3u8)'),
            Text('• Seleção de qualidade'),
            Text('• Picture-in-Picture (PiP)'),
            Text('• Miniplayer com gestos'),
            Text('• Controles de toque duplo'),
            Text('• Animações suaves'),
            Text('• Suporte multiplataforma'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
      ),
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como Usar'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎬 Minimizar:'),
            Text('  • Swipe diagonal (baixo→direita)'),
            Text('  • Botão minimizar'),
            SizedBox(height: 12),
            Text('🔄 Restaurar:'),
            Text('  • Swipe diagonal (cima←esquerda) no miniplayer'),
            Text('  • Botão restaurar'),
            SizedBox(height: 12),
            Text('⏯️ Controles:'),
            Text('  • Toque duplo: ±10 segundos'),
            Text('  • Botão HD: selecionar qualidade'),
            Text('  • PiP: botão ou botão Home'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
      ),
    );
  }
}
