import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/games/dance/repository/danceList.dart';
import 'package:video_player/video_player.dart';

import 'cubit/danceCubit.dart';

class PlayDanceScreen extends StatefulWidget {
  final DanceInfo danceInfo;

  const PlayDanceScreen({
    super.key,
    required this.danceInfo,
  });

  @override
  State<PlayDanceScreen> createState() => _PlayDanceScreenState();
}

class _PlayDanceScreenState extends State<PlayDanceScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DanceCubit>().resetState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    context.read<DanceCubit>().initCamera();
    context.read<DanceCubit>().initVideo(widget.danceInfo.videoPath);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    context.read<DanceCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DanceCubit, DanceState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  context.read<DanceCubit>().changeIsShowing();
                },
                child: state.isVideoInitialized
                    ? VideoPlayer(state.videoController!) : const Center(child: CircularProgressIndicator()),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: DottedBorder(
                  child: Container(
                    width: 120,
                    height: 80,
                    color: Colors.grey,
                    child: state.isCameraInitialized
                        ? CameraPreview(state.cameraController!) : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              if (!state.isReadyToStart)
                Container(
                  color: Colors.black54.withOpacity(0.8),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Image.asset("assets/icon/exit.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/lottie/dog_loading.json",
                            width: 200,
                            height: 200,
                          ),
                          if (!state.isCameraInitialized || !state.isVideoInitialized)
                            const Text("⏳ 로딩중... ⌛",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0
                              ),
                            ),
                          if (state.isVideoInitialized && state.isCameraInitialized)
                            const Text("✅ 준비완료!! ✅",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0
                              ),
                            ),
                          if (!state.isCameraInitialized || !state.isVideoInitialized)
                            const Text("조금만 기달려줘~ 열심히 준비하고 있어!!",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          if (state.isVideoInitialized && state.isCameraInitialized)
                            const Text("놀 준비가 다 됐어~ 준비가 되면 아래 버튼 눌러줘~",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.isVideoInitialized && state.isCameraInitialized)
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<DanceCubit>().startCountdown();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green
                                    ),
                                    child: const Center(
                                      child: Text("준비완료!!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0
                                        ),
                                      ),
                                    )
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ),
              if (state.isReadyToStart && !state.isStart)
                SizedBox.expand(
                  child: Container(
                    color: Colors.black54.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${state.countdown}",
                          style: const TextStyle(
                            fontSize: 70.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                          ),
                        ),
                        const Text("곧! 시작할거야~ 준비해!!",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (state.isShowing)
                GestureDetector(
                  onDoubleTap: () {
                    context.read<DanceCubit>().changeIsShowing();
                  },
                  child: Container(
                    color: Colors.black54.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Image.asset("assets/icon/exit.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Image.asset("assets/icon/undo.png",
                                width: 40,
                                height: 40,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(widget.danceInfo.danceName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.0,
                                ),
                              ),
                              Text("본 영상의 저작권은 '${widget.danceInfo.copyRight}'에 있습니다.",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          )
        );
      }
    );
  }
}