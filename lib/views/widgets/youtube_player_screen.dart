import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class FullScreenPlayerScreen extends StatefulWidget {
  final String videoId;
  const FullScreenPlayerScreen({super.key,required this.videoId});

  @override
  State<FullScreenPlayerScreen> createState() => _FullScreenPlayerScreenState();
}

class _FullScreenPlayerScreenState extends State<FullScreenPlayerScreen> {

  late YoutubePlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=YoutubePlayerController(
      initialVideoId: widget.videoId,  // Example video ID
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          bottomActions: const [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            PlaybackSpeedButton(),
            FullScreenButton()
          ],
        ),
      ),
    );
  }
}
