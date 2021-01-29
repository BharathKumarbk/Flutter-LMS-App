import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:merit_coaching_app1/components/constants.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final String isWatched;
  final String videotitle;

  ChewieListItem({
    Key key,
    @required this.videoPlayerController,
    this.isWatched,
    this.videotitle,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      allowFullScreen: true,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.videotitle}", style: kGoogleNun),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: backColor,
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
