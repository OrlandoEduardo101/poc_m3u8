import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/video_controller.dart';
import '../widgets/custom_video_player.dart';
import '../widgets/mini_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize on first frame to ensure context is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoController>().initialize();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<VideoController>().enterPip();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.watch<VideoController>();
    
    // Se estiver minimizado, volta para a home
    if (vc.isMinimized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('HLS Player PoC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_in_picture_alt),
            onPressed: vc.enterPip,
          ),
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () {
              vc.setMinimized(true);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: const [
              CustomVideoPlayer(),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Role para minimizar. Toque duplo nas laterais para +/-10s. Abra o seletor de qualidade (ícone HD).',
                ),
              ),
              SizedBox(height: 800),
            ],
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}


