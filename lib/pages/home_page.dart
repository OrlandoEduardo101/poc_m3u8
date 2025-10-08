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
              Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, size: 48),
                  title: const Text('Abrir Player de Vídeo'),
                  subtitle: const Text('Inicie o streaming HLS com miniplayer'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoScreen()));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoScreen()));
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
