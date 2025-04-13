import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/detailGame.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';
import 'package:playschool/src/games/drawing/drawingGame.dart';
import 'package:playschool/src/games/fairyTale/completeFairyTale.dart';
import 'package:playschool/src/games/fairyTale/fairyTaleList.dart';
import 'package:playschool/src/games/fairyTale/makeFairyTale.dart';
import 'package:playschool/src/games/fairyTale/selectFairyTale.dart';
import 'package:playschool/src/games/today/puzzleGame/cubit/puzzleCubit.dart';
import 'package:playschool/src/games/today/puzzleGame/puzzle.dart';
import 'package:playschool/src/games/today/wordGame/cubit/wordCubit.dart';
import 'package:playschool/src/games/today/wordGame/word.dart';
import 'package:playschool/src/home.dart';
import 'package:playschool/src/myPage/myPage.dart';
import 'package:playschool/src/authentication/login.dart';
import 'package:playschool/src/authentication/signup.dart';

import 'src/games/fairyTale/fairyTaleList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PuzzleCubit()),
        BlocProvider(create: (context) => WordCubit()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: BG_COLOR
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: "/myPage",
      builder: (context, state) => const MyPageScreen(),
    ),
    GoRoute(
      path: "/puzzleGame",
      builder: (context, state) => const PuzzleGame(),
    ),
    GoRoute(
      path: "/wordGame",
      builder: (context, state) => const wordGame(),
    ),
    GoRoute(
      path: "/detailGame",
      builder: (context, state) {
        final gameData = state.extra as GameData?;
        return DetailGameScreen(gameData: gameData!);
      },
    ),
    GoRoute(
      path: "/drawingGame",
      builder: (context, state) => const DrawingGameScreen(),
    ),
    GoRoute(
      path: "/makeFairyTaleBook",
      builder: (context, state) {
        final gameData = state.extra as GameData?;
        return MakeFairyTaleScreen(gameData: gameData!);
      },
    ),
    GoRoute(
      path: "/selectFairyTaleBook",
      builder: (context, state) {
        final fairyTaleInfo = state.extra as FairyTaleInfo?;
        return SelectFairyTaleScreen(fairyTaleInfo: fairyTaleInfo!);
      },
    ),
    GoRoute(
      path: "/completeFairyTaleBook",
      builder: (context, state) => const CompletefairytaleScreen(),
    )
  ]
);