import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/detailGame.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';
import 'package:playschool/src/games/drawing/drawingGame.dart';
import 'package:playschool/src/games/drawing/drawingdetail.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko', null); // 로케일 초기화

  final storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path)
  );

  HydratedBloc.storage = storage;
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => const AuthRepository(baseUrl: "https://sw-playschool.onrender.com")),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider(create: (context) => PuzzleCubit()),
          BlocProvider(create: (context) => WordCubit()),
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
  // redirect: (context, state) {
  //   final authState = context.read<AuthCubit>().state;
  //   if (authState.authStatus == AuthStatus.complete && state.topRoute!.path == "/login") {
  //     return "/";
  //   }
  //
  //   return null;
  // },
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
  ]
);