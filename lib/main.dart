import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'video_player_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoPlayerProvider(
      hlsUrl: 'https://vz-d6522dee-d49.b-cdn.net/9ee486e7-76c6-40bc-b810-b8882047cead/playlist.m3u8',
      child: MaterialApp(
        title: 'HLS Player PoC',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const HomePage(),
      ),
    );
  }
}
