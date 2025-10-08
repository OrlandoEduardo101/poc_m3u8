import 'package:flutter/material.dart';
import 'package:m3u8_player_plus/m3u8_player_plus.dart';

class SharedVideoPlayerWidget extends StatefulWidget {
  final PlayerConfig config;
  final bool isMinimized;

  const SharedVideoPlayerWidget({super.key, required this.config, required this.isMinimized});

  @override
  State<SharedVideoPlayerWidget> createState() => _SharedVideoPlayerWidgetState();
}

class _SharedVideoPlayerWidgetState extends State<SharedVideoPlayerWidget> {
  static Widget? _playerWidget;
  static PlayerConfig? _currentConfig;

  @override
  Widget build(BuildContext context) {
    // Se a config mudou ou não temos player, criar um novo
    if (_playerWidget == null || _currentConfig != widget.config) {
      _currentConfig = widget.config;
      _playerWidget = M3u8PlayerWidget(config: widget.config);
    }

    return SizedBox(
      width: widget.isMinimized ? 80 : double.infinity,
      height: widget.isMinimized ? 45 : null,
      child: widget.isMinimized
          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: _playerWidget!)
          : _playerWidget!,
    );
  }
}
