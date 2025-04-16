import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/detailGame.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';
import 'package:playschool/src/home.dart';
import 'package:playschool/src/myPage/myPage.dart';
import 'package:playschool/src/puzzleGame/cubit/puzzleCubit.dart';
import 'package:playschool/src/puzzleGame/puzzle.dart';
import 'package:playschool/src/authentication/login.dart';
import 'package:playschool/src/authentication/signup.dart';
import 'package:playschool/src/common/detailGame/games/drawing/drawingGame.dart';
import 'package:playschool/src/common/detailGame/games/drawing/drawingdetail.dart';
import 'package:playschool/test.dart';
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
        BlocProvider(create: (context) => PuzzleCubit())
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
      path: '/drawingDetail',
      builder: (context, state) {
        final name = state.extra != null ? (state.extra as Map)['name'] : '';
        final imagePath = state.extra != null ? (state.extra as Map)['imagePath'] : '';
        return DrawingDetailScreen(name: name, imagePath: imagePath);
      },
    ),
    
  ]
);