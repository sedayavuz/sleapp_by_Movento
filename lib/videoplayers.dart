import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VideoPlayersState();
}

class VideoPlayersState extends State {
  VideoPlayerController _controller;
  bool durum = true;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/video/yoga.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/Android Mobile – Settings Alarm – 2.png',
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: GestureDetector(
                    child: VideoPlayer(_controller),
                    onTap: () {
                      setState(() {
                        durum = true;
                        if (_controller.value.isPlaying)
                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            setState(() {
                              if (!_controller.value.isPlaying)
                                durum = true;
                              else
                                durum = false;
                              print('Durum false3');
                            });
                          });
                      });
                    },
                  ),
                )
              : Container(),
        ),
        Center(
          child: !durum
              ? Container()
              : FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                        setState(() {
                          durum = true;
                          print('Durum false1');
                        });
                      } else {
                        _controller.play();
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            durum = false;
                            print('Durum false2');
                          });
                        });
                      }
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 40.0,
                    color: Colors.grey[200],
                  ),
                ),
        )
      ],
    ));
  }
}
