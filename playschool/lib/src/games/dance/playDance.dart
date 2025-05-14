import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';
import 'package:playschool/src/games/dance/repository/danceList.dart';
import 'package:playschool/src/games/repository/GameRepository.dart';
import 'package:video_player/video_player.dart';

import '../../common/component/color.dart';
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
    return BlocListener<DanceCubit, DanceState>(
      listenWhen: (previous, current) => previous.danceStatus != current.danceStatus,
      listener: (context, state) {
        if (state.danceStatus == DanceStatus.error) {
          if (context.canPop()) { context.pop(); }
          _showFailedAlert(context);
        }

        if (state.danceStatus == DanceStatus.complete) {
          if (context.canPop()) { context.pop(); }
          context.read<AuthRepository>().userExpUp(context, context.read<AuthCubit>().state.token!);
          context.read<GameRepository>().updateGame(context, 3, context.read<AuthCubit>().state.token!);
          context.go("/completeDance", extra: widget.danceInfo);
        }
      },
      child: BlocBuilder<DanceCubit, DanceState>(
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
                        ? RotatedBox(
                          quarterTurns: 3,
                          child: CameraPreview(state.cameraController!)
                        ) : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                // 게임 시작하기 전 ( 비디오 및 카메라 설정단계 )
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
                                style: TextStyle(
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
                // 시작버튼은 눌렀으나 아직 게임은 시작하지 않음.
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
                // 게임이 끝났을 때
                if (state.isFinish)
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
                              const Text("✅ 게임종료!! ✅",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                ),
                              ),
                              const Text("정말 수고했어~! 평가 단계로 넘어갈까~??",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _showLoadingAlert(context);
                                        await context.read<DanceCubit>().assessmentStart();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange
                                      ),
                                      child: const Center(
                                        child: Text("평가하기!!",
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
                // 게임을 일시정지 했을 때
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
      ),
    );
  }

  void _showLoadingAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 모서리 둥글게
            ),
            backgroundColor: BG_COLOR,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/lottie/loading.json",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text("⌛️ 채점 중 ... ⏳",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                  ),
                ),
                Text("열심히 너의 춤을 분석하고 있어!!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
                Text("조금만 기달려줭~",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void _showFailedAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 3), () {
            if(Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 모서리 둥글게
            ),
            backgroundColor: BG_COLOR,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/lottie/failed.json",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(" 에러 발생 ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                  ),
                ),
                Text("힝.. 채점에 실패했어!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
                Text("다시 시도해봐!!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}