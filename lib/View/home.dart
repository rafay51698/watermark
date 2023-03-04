import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark/Controller/merge_provider.dart';
import 'package:watermark/const/path.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  MyController controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watermark Video"),
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.pickVideo();
                },
                child: const Text("Select Video"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.pickPhoto();
                },
                child: const Text("Select Image"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.addWatermarkToVideo();
                },
                child: const Text("Proceed"),
              ),
              Obx(() => controller.image.value.path != ""
                  ? Expanded(
                      child: Image(
                      image: FileImage(File(controller.image.value.path)),
                    ))
                  : Container()),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   child: SizedBox(
              //     height: MediaQuery.of(context).size.height * 0.4,
              //     child: PlayVideo(
              //       pathh: File(controller.output.value),
              //     ),
              //   ),
              // )
            ],
          );
        },
      ),
    );
  }
}

class PlayVideo extends StatefulWidget {
  var pathh;

  @override
  _PlayVideoState createState() => _PlayVideoState();

  PlayVideo({
    Key? key,
    this.pathh, // Video from assets folder
  }) : super(key: key);
}

class _PlayVideoState extends State<PlayVideo> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.file(widget.pathh);
    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller!.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SizedBox(
              height: controller!.value.size.height,
              width: double.infinity,
              child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: Stack(children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: VideoPlayer(
                          controller!,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(
                            // flex: 8,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: IconButton(
                                      icon: Icon(
                                        controller!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (controller!.value.isPlaying) {
                                            controller!.pause();
                                          } else {
                                            controller!.play();
                                          }
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
            ),
          );
        }
      },
    );
  }
}
