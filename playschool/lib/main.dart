import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';
import 'package:playschool/src/authentication/cubit/userCubit.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/detailGame.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';
import 'package:playschool/src/games/dance/completeDance.dart';
import 'package:playschool/src/games/dance/cubit/danceCubit.dart';
import 'package:playschool/src/games/dance/cubit/popUpDanceCubit.dart';
import 'package:playschool/src/games/dance/playDance.dart';
import 'package:playschool/src/games/dance/repository/DanceRepository.dart';
import 'package:playschool/src/games/dance/repository/danceList.dart';
import 'package:playschool/src/games/dance/selectDance.dart';
import 'package:playschool/src/games/drawing/drawingGame.dart';
import 'package:playschool/src/games/drawing/drawingdetail.dart';
import 'package:playschool/src/games/fairyTale/completeFairyTale.dart';
import 'package:playschool/src/games/fairyTale/repository/fairyTaleList.dart';
import 'package:playschool/src/games/fairyTale/makeFairyTale.dart';
import 'package:playschool/src/games/fairyTale/selectFairyTale.dart';
import 'package:playschool/src/games/repository/GameRepository.dart';
import 'package:playschool/src/games/today/puzzleGame/cubit/puzzleCubit.dart';
import 'package:playschool/src/games/today/puzzleGame/puzzle.dart';
import 'package:playschool/src/games/today/wordGame/cubit/wordCubit.dart';
import 'package:playschool/src/games/today/wordGame/word.dart';
import 'package:playschool/src/home.dart';
import 'package:playschool/src/myPage/myPage.dart';
import 'package:playschool/src/authentication/login.dart';
import 'package:playschool/src/authentication/signup.dart';
import 'package:playschool/src/games/word_matching/word_matching_game.dart';
import 'package:playschool/src/games/word_matching/word_matching_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko', null);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final baseUrl = "https://sw-playschool.onrender.com";
  final danceApiUrl = "https://sw-playschool-danceapi.onrender.com";

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository(baseUrl: baseUrl)),
        RepositoryProvider(create: (context) => GameRepository(baseUrl: baseUrl)),
        RepositoryProvider(create: (context) => DanceRepository(baseUrl: danceApiUrl)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserCubit()),
          BlocProvider(create: (context) => AuthCubit(userCubit: context.read<UserCubit>(), authRepository: context.read<AuthRepository>())),
          BlocProvider(create: (context) => PuzzleCubit()),
          BlocProvider(create: (context) => WordCubit()),
          BlocProvider(create: (context) => PopDanceCubit()),
          BlocProvider(create: (context) => DanceCubit(danceRepository: context.read<DanceRepository>())),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            _router.refresh();
          },
          child: MaterialApp.router(
            theme: ThemeData(
              scaffoldBackgroundColor: BG_COLOR
            ),
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    if (authState.authStatus == AuthStatus.complete && state.topRoute!.path == "/login") {
      return "/";
    }

    return null;
  },
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
      path: '/drawingDetail',
      builder: (context, state) {
        final name = state.extra != null ? (state.extra as Map)['name'] : '';
        final imagePath = state.extra != null ? (state.extra as Map)['imagePath'] : '';
        return DrawingDetailScreen(name: name, imagePath: imagePath);
      },
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
      builder: (context, state) {
        // final args = state.extra as Map<String, dynamic>?;
        // return CompleteFairyTaleScreen(args: args!);
        return CompleteFairyTaleScreen();
      },
    ),
    GoRoute(
      path: "/selectDance",
      builder: (context, state) {
        final gameData = state.extra as GameData?;
        return SelectDanceScreen(gameData: gameData!);
      }
    ),
    GoRoute(
      path: "/playDance",
      builder: (context, state) {
        final danceInfo = state.extra as DanceInfo?;
        return PlayDanceScreen(danceInfo: danceInfo!);
      }
    ),
    GoRoute(
      path: "/completeDance",
      builder: (context, state) {
        final danceInfo = state.extra as DanceInfo?;
        return CompleteDanceScreen(danceInfo: danceInfo!);
      }
    ),
    GoRoute(
      path: "/word_matching",
      builder: (context, state) => const WordMatching(),
    ),
    GoRoute(
      path: '/word_matching_detail',
      builder: (context, state) {
        final label = (state.extra as Map?)?['label'] ?? '';
        return WordMatchingDetail(label: label);
      },
    ),
  ]
);