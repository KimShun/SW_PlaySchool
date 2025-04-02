import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/detailGame.dart';
import 'package:playschool/src/home.dart';
import 'package:playschool/src/myPage/myPage.dart';
import 'package:playschool/src/puzzleGame/cubit/puzzleCubit.dart';
import 'package:playschool/src/puzzleGame/puzzle.dart';

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
  initialLocation: "/detailGame",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
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
      builder: (context, state) => const DetailGameScreen(),
    )
  ]
);